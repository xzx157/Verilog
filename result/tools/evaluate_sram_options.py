#!/usr/bin/env python3
"""Rank SRAM macro and compute-array options for Lab8.

This is an analytical pre-selection tool. It enumerates SRAM macro types and
possible A/B compute tile sizes, then estimates latency/power/area score with
the same score formula used in the report. The model treats each SRAM word as a
packed vector of INT8 lanes and tries to use both SRAM width and depth:

* IO width supplies multiple A rows or B columns at the same K index.
* SRAM depth supplies a K chunk. If the macro is shallower than K=512, multiple
  K chunks are accumulated; if it is deeper than K=512, unused depth is shown in
  the capacity utilization.

The output is for choosing a few RTL experiments, not for final PPA evidence.
Final latency still needs a full remote pre-syn run, and final power/area still
needs DC plus the selected SRAM analytical power.
"""

from __future__ import annotations

import argparse
import math
import re
from dataclasses import dataclass
from pathlib import Path


DEFAULT_SRAM_MD = Path(__file__).resolve().parents[1] / "main" / "sram.md"


@dataclass(frozen=True)
class SramSpec:
    no: int
    words: int
    io_bits: int
    area_um2: float
    leakage_uw: float
    dynamic_uw_per_mhz: float

    @property
    def int8_per_word(self) -> int:
        return self.io_bits // 8


@dataclass(frozen=True)
class Candidate:
    spec: SramSpec
    a_rows: int
    b_cols: int
    acc_bits: int
    pe_count: int
    a_sram_count: int
    b_sram_count: int
    sram_count: int
    k_chunk: int
    k_chunks: int
    row_tiles: int
    col_tiles: int
    capacity_utilization: float
    lane_utilization: float
    load_cycles_per_chunk: int
    compute_cycles_per_chunk: int
    write_cycles_per_tile: int
    tile_cycles: int
    total_cycles: int
    shortest_period_ps: float
    latency_ns: float
    latency_us: float
    freq_mhz: float
    logic_area_um2: float
    sram_area_um2: float
    score_area_um2: float
    logic_dynamic_mw: float
    logic_leakage_mw: float
    sram_dynamic_mw: float
    sram_leakage_mw: float
    total_power_mw: float
    score: float
    meets_power: bool
    meets_latency: bool


def parse_sram_table(path: Path) -> list[SramSpec]:
    specs: list[SramSpec] = []
    line_re = re.compile(
        r"^\s*(\d+)\s+(\d+)\s+(\d+)\s+\S+\s+"
        r"([0-9.]+)\s+([0-9.]+)\s+([0-9.]+)\s*$"
    )
    for line in path.read_text(encoding="utf-8").splitlines():
        match = line_re.match(line)
        if not match:
            continue
        no, words, io_bits, area, leakage, dynamic = match.groups()
        specs.append(
            SramSpec(
                no=int(no),
                words=int(words),
                io_bits=int(io_bits),
                area_um2=float(area),
                leakage_uw=float(leakage),
                dynamic_uw_per_mhz=float(dynamic),
            )
        )
    if not specs:
        raise RuntimeError(f"No SRAM specs parsed from {path}")
    return specs


def parse_int_list(text: str) -> list[int]:
    values: list[int] = []
    for part in text.split(","):
        part = part.strip()
        if part:
            values.append(int(part))
    if not values:
        raise argparse.ArgumentTypeError("expected at least one integer")
    return values


def ceil_div(a: int, b: int) -> int:
    return (a + b - 1) // b


def scaled_logic_value(baseline: float, pe_ratio: float, fixed_fraction: float) -> float:
    return baseline * (fixed_fraction + (1.0 - fixed_fraction) * pe_ratio)


def accumulator_scale(acc_bits: int, args: argparse.Namespace) -> float:
    bit_ratio = acc_bits / args.baseline_acc_bits
    return 1.0 - args.accumulator_scalable_fraction * (1.0 - bit_ratio)


def estimate_candidate(
    spec: SramSpec,
    a_rows: int,
    b_cols: int,
    acc_bits: int,
    args: argparse.Namespace,
) -> Candidate | None:
    if spec.io_bits % 8 != 0:
        return None
    int8_per_word = spec.int8_per_word
    if int8_per_word <= 0:
        return None

    k_chunk = min(spec.words, args.matrix_size)
    k_chunks = ceil_div(args.matrix_size, k_chunk)
    row_tiles = ceil_div(args.matrix_size, a_rows)
    col_tiles = ceil_div(args.matrix_size, b_cols)

    a_sram_count = ceil_div(a_rows, int8_per_word)
    b_sram_count = ceil_div(b_cols, int8_per_word)
    sram_count = a_sram_count + b_sram_count
    if sram_count > args.max_sram_count:
        return None

    if args.require_even_lane_groups and (a_rows % int8_per_word != 0 or b_cols % int8_per_word != 0):
        return None

    pe_count = a_rows * b_cols
    if pe_count > args.max_pe_count:
        return None

    a_capacity_bytes = a_sram_count * spec.words * int8_per_word
    b_capacity_bytes = b_sram_count * spec.words * int8_per_word
    a_used_bytes = a_rows * k_chunk
    b_used_bytes = b_cols * k_chunk
    capacity_utilization = (a_used_bytes + b_used_bytes) / (a_capacity_bytes + b_capacity_bytes)
    lane_utilization = (a_rows + b_cols) / ((a_sram_count + b_sram_count) * int8_per_word)
    if capacity_utilization < args.min_capacity_utilization:
        return None

    cycles_per_sram_word = args.sram_word_cycle_overhead * ceil_div(spec.io_bits, args.input_bus_bits)
    a_load_cycles_per_chunk = a_sram_count * k_chunk * cycles_per_sram_word
    b_load_cycles_per_chunk = b_sram_count * k_chunk * cycles_per_sram_word
    load_cycles_per_chunk = a_load_cycles_per_chunk + b_load_cycles_per_chunk
    compute_cycles_per_chunk = k_chunk * args.compute_cycles_per_k + args.compute_pipeline_overhead
    write_cycles_per_tile = ceil_div(a_rows * b_cols, args.result_int32_per_word) * args.result_word_cycle_overhead
    if args.b_reuse_across_rows:
        tile_cycles = (
            k_chunks * (a_load_cycles_per_chunk + compute_cycles_per_chunk + args.k_chunk_overhead)
            + write_cycles_per_tile
            + args.tile_overhead
        )
        total_cycles = 1 + col_tiles * (k_chunks * b_load_cycles_per_chunk + row_tiles * tile_cycles)
    else:
        tile_cycles = (
            k_chunks * (load_cycles_per_chunk + compute_cycles_per_chunk + args.k_chunk_overhead)
            + write_cycles_per_tile
            + args.tile_overhead
        )
        total_cycles = 1 + row_tiles * col_tiles * tile_cycles

    shortest_period_ps = args.target_ps - args.setup_slack_ps
    if shortest_period_ps <= 0:
        raise ValueError("target_ps - setup_slack_ps must be positive")
    latency_ns = total_cycles * shortest_period_ps / 1000.0
    latency_us = latency_ns / 1000.0
    freq_mhz = 1_000_000.0 / args.target_ps

    effective_pe_ratio = (pe_count / args.baseline_pe_count) * accumulator_scale(acc_bits, args)
    logic_area_um2 = scaled_logic_value(args.logic_area_um2, effective_pe_ratio, args.logic_fixed_fraction)
    logic_dynamic_mw_at_target = scaled_logic_value(
        args.logic_dynamic_mw_at_target, effective_pe_ratio, args.logic_power_fixed_fraction
    )
    logic_leakage_mw = scaled_logic_value(args.logic_leakage_mw, effective_pe_ratio, args.logic_power_fixed_fraction)
    logic_dynamic_mw = logic_dynamic_mw_at_target

    sram_area_um2 = sram_count * spec.area_um2
    sram_leakage_mw = sram_count * spec.leakage_uw / 1000.0
    sram_dynamic_mw = sram_count * spec.dynamic_uw_per_mhz * freq_mhz / 1000.0
    total_power_mw = logic_dynamic_mw + logic_leakage_mw + sram_dynamic_mw + sram_leakage_mw

    score_area_um2 = logic_area_um2 + (sram_area_um2 if args.area_mode == "logic-plus-sram" else 0.0)
    score = math.exp(args.sse / args.c0) * total_power_mw * (score_area_um2**2) * latency_us

    return Candidate(
        spec=spec,
        a_rows=a_rows,
        b_cols=b_cols,
        acc_bits=acc_bits,
        pe_count=pe_count,
        a_sram_count=a_sram_count,
        b_sram_count=b_sram_count,
        sram_count=sram_count,
        k_chunk=k_chunk,
        k_chunks=k_chunks,
        row_tiles=row_tiles,
        col_tiles=col_tiles,
        capacity_utilization=capacity_utilization,
        lane_utilization=lane_utilization,
        load_cycles_per_chunk=load_cycles_per_chunk,
        compute_cycles_per_chunk=compute_cycles_per_chunk,
        write_cycles_per_tile=write_cycles_per_tile,
        tile_cycles=tile_cycles,
        total_cycles=total_cycles,
        shortest_period_ps=shortest_period_ps,
        latency_ns=latency_ns,
        latency_us=latency_us,
        freq_mhz=freq_mhz,
        logic_area_um2=logic_area_um2,
        sram_area_um2=sram_area_um2,
        score_area_um2=score_area_um2,
        logic_dynamic_mw=logic_dynamic_mw,
        logic_leakage_mw=logic_leakage_mw,
        sram_dynamic_mw=sram_dynamic_mw,
        sram_leakage_mw=sram_leakage_mw,
        total_power_mw=total_power_mw,
        score=score,
        meets_power=(total_power_mw * 1e9) < args.power_limit_pw,
        meets_latency=latency_ns < args.latency_limit_ns,
    )


def format_table(candidates: list[Candidate], *, baseline_score: float | None) -> str:
    lines = [
        "| Rank | No. | Word | IO | A_ROWS | B_COLS | ACC | PEs | SRAM A+B | K chunk | Cap util. | Lane util. | Tile cycles | Cycles | Latency ns | Power pW | SRAM area | Logic area | Score | Quality vs base | Target |",
        "|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|",
    ]
    for rank, item in enumerate(candidates, 1):
        quality = baseline_score / item.score if baseline_score is not None else float("nan")
        target = "Y" if item.meets_power and item.meets_latency else "N"
        lines.append(
            "| {rank} | {no} | {words} | {io} | {a_rows} | {b_cols} | {acc_bits} | {pes} | "
            "{a_sram}+{b_sram} | {k_chunk}x{k_chunks} | {cap:.1%} | {lane:.1%} | "
            "{tile_cycles:,} | {cycles:,} | {latency:,.0f} | {power:.0f} | "
            "{sram_area:.1f} | {logic_area:.1f} | {score:.6E} | {quality:.3f} | {target} |".format(
                rank=rank,
                no=item.spec.no,
                words=item.spec.words,
                io=item.spec.io_bits,
                a_rows=item.a_rows,
                b_cols=item.b_cols,
                acc_bits=item.acc_bits,
                pes=item.pe_count,
                a_sram=item.a_sram_count,
                b_sram=item.b_sram_count,
                k_chunk=item.k_chunk,
                k_chunks=item.k_chunks,
                cap=item.capacity_utilization,
                lane=item.lane_utilization,
                tile_cycles=item.tile_cycles,
                cycles=item.total_cycles,
                latency=item.latency_ns,
                power=item.total_power_mw * 1e9,
                sram_area=item.sram_area_um2,
                logic_area=item.logic_area_um2,
                score=item.score,
                quality=quality,
                target=target,
            )
        )
    return "\n".join(lines)


def sort_key(candidate: Candidate, mode: str, args: argparse.Namespace) -> tuple[float, ...]:
    if mode == "score":
        return (candidate.score,)
    if mode == "latency":
        return (candidate.latency_ns, candidate.score)
    if mode == "util-score":
        return (-candidate.capacity_utilization, -candidate.lane_utilization, candidate.score)
    if mode == "target-score":
        latency_miss = max(0.0, candidate.latency_ns - args.latency_limit_ns) / args.latency_limit_ns
        power_pw = candidate.total_power_mw * 1e9
        power_miss = max(0.0, power_pw - args.power_limit_pw) / args.power_limit_pw
        return (
            0.0 if candidate.meets_power and candidate.meets_latency else 1.0,
            0.0 if candidate.meets_latency else 1.0,
            latency_miss,
            0.0 if candidate.meets_power else 1.0,
            power_miss,
            candidate.score,
        )
    raise ValueError(f"Unknown sort mode: {mode}")


def ranking_summary(candidates: list[Candidate], args: argparse.Namespace) -> str:
    target_hits = [item for item in candidates if item.meets_power and item.meets_latency]
    latency_hits = [item for item in candidates if item.meets_latency]
    power_hits = [item for item in candidates if item.meets_power]
    lines = ["## Target Summary", ""]
    lines.append(f"候选总数：`{len(candidates)}`；满足 power+latency 的候选数：`{len(target_hits)}`。")
    if target_hits:
        best = min(target_hits, key=lambda item: item.score)
        lines.append(
            "最佳达标候选：No.{no} `{words}x{io}`，`{a_rows}x{b_cols}`，ACC `{acc_bits}`，"
            "power `{power:.0f} pW`，latency `{latency:.0f} ns`。".format(
                no=best.spec.no,
                words=best.spec.words,
                io=best.spec.io_bits,
                a_rows=best.a_rows,
                b_cols=best.b_cols,
                acc_bits=best.acc_bits,
                power=best.total_power_mw * 1e9,
                latency=best.latency_ns,
            )
        )
    else:
        if latency_hits:
            best_power_under_latency = min(latency_hits, key=lambda item: item.total_power_mw)
            lines.append(
                "没有候选同时达标。满足 latency 的最低功耗候选是 No.{no} `{words}x{io}`，"
                "`{a_rows}x{b_cols}`，ACC `{acc_bits}`，power `{power:.0f} pW`，"
                "是目标的 `{power_ratio:.2f}x`。".format(
                    no=best_power_under_latency.spec.no,
                    words=best_power_under_latency.spec.words,
                    io=best_power_under_latency.spec.io_bits,
                    a_rows=best_power_under_latency.a_rows,
                    b_cols=best_power_under_latency.b_cols,
                    acc_bits=best_power_under_latency.acc_bits,
                    power=best_power_under_latency.total_power_mw * 1e9,
                    power_ratio=(best_power_under_latency.total_power_mw * 1e9) / args.power_limit_pw,
                )
            )
        if power_hits:
            best_latency_under_power = min(power_hits, key=lambda item: item.latency_ns)
            lines.append(
                "满足 power 的最低 latency 候选是 No.{no} `{words}x{io}`，`{a_rows}x{b_cols}`，"
                "ACC `{acc_bits}`，latency `{latency:.0f} ns`，是目标的 `{latency_ratio:.2f}x`。".format(
                    no=best_latency_under_power.spec.no,
                    words=best_latency_under_power.spec.words,
                    io=best_latency_under_power.spec.io_bits,
                    a_rows=best_latency_under_power.a_rows,
                    b_cols=best_latency_under_power.b_cols,
                    acc_bits=best_latency_under_power.acc_bits,
                    latency=best_latency_under_power.latency_ns,
                    latency_ratio=best_latency_under_power.latency_ns / args.latency_limit_ns,
                )
            )
        else:
            lowest_power = min(candidates, key=lambda item: item.total_power_mw)
            lines.append(
                "没有候选满足 power。全表最低功耗候选是 No.{no} `{words}x{io}`，`{a_rows}x{b_cols}`，"
                "ACC `{acc_bits}`，power `{power:.0f} pW`，是目标的 `{power_ratio:.2f}x`；"
                "latency `{latency:.0f} ns`，是目标的 `{latency_ratio:.2f}x`。".format(
                    no=lowest_power.spec.no,
                    words=lowest_power.spec.words,
                    io=lowest_power.spec.io_bits,
                    a_rows=lowest_power.a_rows,
                    b_cols=lowest_power.b_cols,
                    acc_bits=lowest_power.acc_bits,
                    power=lowest_power.total_power_mw * 1e9,
                    power_ratio=(lowest_power.total_power_mw * 1e9) / args.power_limit_pw,
                    latency=lowest_power.latency_ns,
                    latency_ratio=lowest_power.latency_ns / args.latency_limit_ns,
                )
            )
    lines.append("")
    return "\n".join(lines)


def scoring_standard(args: argparse.Namespace) -> str:
    shortest_period_ps = args.target_ps - args.setup_slack_ps
    power_frequency_mhz = 1_000_000.0 / args.target_ps
    return "\n".join(
        [
            "## Scoring Standard",
            "",
            "候选空间：对 `sram.md` 中每个 SRAM macro，枚举 `A_ROWS x B_COLS` 计算阵列。",
            f"默认 `A_ROWS, B_COLS in {args.a_rows}`，`PEs = A_ROWS * B_COLS <= {args.max_pe_count}`，"
            f"`ACC_BITS in {args.acc_bits}`，`SRAM count <= {args.max_sram_count}`。",
            "",
            "SRAM packing：",
            "",
            "- `int8_per_word = IO_bits / 8`，只考虑 IO 位宽能整除 8 的 macro。",
            "- `K_chunk = min(SRAM_words, 512)`，`K_chunks = ceil(512 / K_chunk)`。",
            "- `A_SRAM = ceil(A_ROWS / int8_per_word)`，`B_SRAM = ceil(B_COLS / int8_per_word)`。",
            "- `capacity_utilization = (A_ROWS*K_chunk + B_COLS*K_chunk) / ((A_SRAM+B_SRAM)*SRAM_words*int8_per_word)`。",
            "- `lane_utilization = (A_ROWS+B_COLS) / ((A_SRAM+B_SRAM)*int8_per_word)`。",
            f"- 默认过滤 `capacity_utilization >= {args.min_capacity_utilization:.0%}`，因此优先选择能把 SRAM macro 装满的组合。",
            "",
            "Cycle and latency estimate：",
            "",
            f"- `cycles_per_sram_word = {args.sram_word_cycle_overhead} * ceil(IO_bits / {args.input_bus_bits})`。",
            "- `A_load_cycles_per_chunk = A_SRAM * K_chunk * cycles_per_sram_word`。",
            "- `B_load_cycles_per_chunk = B_SRAM * K_chunk * cycles_per_sram_word`。",
            f"- `compute_cycles_per_chunk = K_chunk * {args.compute_cycles_per_k} + {args.compute_pipeline_overhead}`。",
            f"- `write_cycles_per_tile = ceil(A_ROWS*B_COLS / {args.result_int32_per_word}) * {args.result_word_cycle_overhead}`。",
            f"- `tile_cycles = K_chunks*(A_load_cycles_per_chunk + compute_cycles_per_chunk + {args.k_chunk_overhead}) + write_cycles_per_tile + {args.tile_overhead}` when B reuse is enabled。",
            "- `total_cycles = 1 + col_tiles * (K_chunks*B_load_cycles_per_chunk + row_tiles*tile_cycles)` when B reuse is enabled。",
            f"- B reuse across row tiles: `{args.b_reuse_across_rows}`。When disabled, `tile_cycles` includes both A and B load and `total_cycles = 1 + row_tiles*col_tiles*tile_cycles`。",
            f"- `shortest_period = target_period - setup_slack = {args.target_ps:.2f} ps - {args.setup_slack_ps:.2f} ps = {shortest_period_ps:.2f} ps`。",
            "- `latency_ns = total_cycles * shortest_period_ps / 1000`。",
            "",
            "Power and area estimate：",
            "",
            f"- `power_frequency_MHz = 1e6 / target_period_ps = {power_frequency_mhz:.3f} MHz`。",
            f"- Baseline logic: area `{args.logic_area_um2:.6f} um^2`, dynamic `{args.logic_dynamic_mw_at_target:.4f} mW @ {args.target_ps:.0f} ps`, leakage `{args.logic_leakage_mw:.4f} mW`, baseline PEs `{args.baseline_pe_count}`。",
            f"- Logic scaling uses `baseline * ({args.logic_fixed_fraction:.2f} + {1.0 - args.logic_fixed_fraction:.2f} * PEs/{args.baseline_pe_count})` for area, and the same fixed fraction `{args.logic_power_fixed_fraction:.2f}` for dynamic/leakage power。",
            f"- Accumulator narrowing is modeled by multiplying the scalable PE term by `1 - {args.accumulator_scalable_fraction:.2f} * (1 - ACC_BITS/{args.baseline_acc_bits})`。这是 24-bit accumulator 的预估项，不替代 DC 综合。",
            "- `logic_dynamic_mW = scaled_dynamic_at_target`，不按 shortest period 重新缩放。",
            "- `sram_power_mW = (A_SRAM+B_SRAM) * (leakage_uW + dynamic_uW_per_MHz*power_frequency_MHz) / 1000`。",
            "- `total_power_mW = logic_dynamic_mW + logic_leakage_mW + sram_power_mW`。",
            "- `score_area = logic_area` when `area-mode=logic-only`; `score_area = logic_area + sram_area` when `area-mode=logic-plus-sram`。",
            "",
            "Final score and sorting：",
            "",
            f"- `Score = exp(SSE/{args.c0:g}) * total_power_mW * score_area^2 * latency_us`，默认 `SSE={args.sse:g}`。",
            "- Score 越低越好；`Quality vs base = baseline_score / candidate_score`，所以 quality 越高越好。",
            f"- `Target = Y` means `power < {args.power_limit_pw:.3g} pW` and `latency < {args.latency_limit_ns:.3g} ns`。",
            "- `sort-mode=target-score` 的排序键是：先满足 power+latency，再满足 latency，再按 latency miss、power miss、score 排序。",
            "",
        ]
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Rank Lab8 SRAM macro and compute-array options")
    parser.add_argument("--sram-md", type=Path, default=DEFAULT_SRAM_MD)
    parser.add_argument("--top", type=int, default=20)
    parser.add_argument("--markdown-out", type=Path, default=None)
    parser.add_argument("--area-mode", choices=["logic-only", "logic-plus-sram"], default="logic-only")
    parser.add_argument(
        "--sort-mode",
        choices=["target-score", "score", "latency", "util-score"],
        default="target-score",
    )
    parser.add_argument("--baseline-no", type=int, default=35)
    parser.add_argument("--baseline-a-rows", type=int, default=12)
    parser.add_argument("--baseline-b-cols", type=int, default=16)

    parser.add_argument("--matrix-size", type=int, default=512)
    parser.add_argument("--a-rows", type=parse_int_list, default=parse_int_list("4,8,12,16,24,32,48,64"))
    parser.add_argument("--b-cols", type=parse_int_list, default=parse_int_list("4,8,12,16,24,32,48,64"))
    parser.add_argument("--acc-bits", type=parse_int_list, default=parse_int_list("24,25,32"))
    parser.add_argument("--max-pe-count", type=int, default=4096)
    parser.add_argument("--max-sram-count", type=int, default=64)
    parser.add_argument("--min-capacity-utilization", type=float, default=0.95)
    parser.add_argument("--require-even-lane-groups", action="store_true")

    parser.add_argument("--input-bus-bits", type=int, default=64)
    parser.add_argument("--result-int32-per-word", type=int, default=2)
    parser.add_argument("--sram-word-cycle-overhead", type=int, default=2)
    parser.add_argument("--result-word-cycle-overhead", type=int, default=2)
    parser.add_argument("--compute-cycles-per-k", type=int, default=3)
    parser.add_argument("--compute-pipeline-overhead", type=int, default=0)
    parser.add_argument("--k-chunk-overhead", type=int, default=8)
    parser.add_argument("--tile-overhead", type=int, default=16)
    parser.add_argument("--b-reuse-across-rows", action=argparse.BooleanOptionalAction, default=True)

    parser.add_argument("--target-ps", type=float, default=2000.00)
    parser.add_argument("--setup-slack-ps", type=float, default=1593.02)
    parser.add_argument("--logic-area-um2", type=float, default=36376.658457)
    parser.add_argument("--logic-dynamic-mw-at-target", type=float, default=11.9860)
    parser.add_argument("--logic-leakage-mw", type=float, default=42.8377)
    parser.add_argument("--baseline-pe-count", type=int, default=12 * 16)
    parser.add_argument("--baseline-acc-bits", type=int, default=32)
    parser.add_argument("--accumulator-scalable-fraction", type=float, default=0.50)
    parser.add_argument("--logic-fixed-fraction", type=float, default=0.20)
    parser.add_argument("--logic-power-fixed-fraction", type=float, default=0.20)
    parser.add_argument("--sse", type=float, default=0.0)
    parser.add_argument("--c0", type=float, default=1e-3)
    parser.add_argument("--power-limit-pw", type=float, default=2e10)
    parser.add_argument("--latency-limit-ns", type=float, default=2.5e6)
    return parser


def main() -> None:
    args = build_parser().parse_args()
    specs = parse_sram_table(args.sram_md)

    candidates: list[Candidate] = []
    for spec in specs:
        for a_rows in args.a_rows:
            for b_cols in args.b_cols:
                for acc_bits in args.acc_bits:
                    candidate = estimate_candidate(spec, a_rows, b_cols, acc_bits, args)
                    if candidate is not None:
                        candidates.append(candidate)
    if not candidates:
        raise RuntimeError("No valid candidates. Relax array ranges, SRAM count, or utilization filters.")
    candidates.sort(key=lambda item: sort_key(item, args.sort_mode, args))

    baseline = next(
        (
            item
            for item in candidates
            if item.spec.no == args.baseline_no
            and item.a_rows == args.baseline_a_rows
            and item.b_cols == args.baseline_b_cols
            and item.acc_bits == args.baseline_acc_bits
        ),
        None,
    )
    baseline_score = baseline.score if baseline is not None else None
    selected = candidates[: args.top]

    text = "\n".join(
        [
            "# SRAM Candidate Ranking",
            "",
            "排序：Lab8 score 从低到高；`Quality vs base = baseline score / candidate score`，所以 quality 越高越好。",
            f"Area mode: `{args.area_mode}`",
            f"Sort mode: `{args.sort_mode}`",
            "",
            "模型：枚举 SRAM 型号与 `A_ROWS x B_COLS` 计算阵列；SRAM word 的 byte lanes 用来并行提供多行 A 或多列 B，"
            "SRAM depth 用作 K chunk，尽量装满 macro 容量。此表用于挑 RTL 实验点，最终结果仍以远端 pre-syn/full check 和 DC PPA 为准。",
            "",
            scoring_standard(args),
            ranking_summary(candidates, args),
            format_table(selected, baseline_score=baseline_score),
            "",
        ]
    )
    print(text)
    if args.markdown_out is not None:
        args.markdown_out.parent.mkdir(parents=True, exist_ok=True)
        args.markdown_out.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    main()
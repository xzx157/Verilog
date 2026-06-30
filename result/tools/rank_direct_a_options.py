#!/usr/bin/env python3
"""Rank fixed-1ns direct-A Lab8 options.

Model calibrated to version 6: direct A word buffers, B SRAM tile reuse,
one B SRAM read setup cycle per 8-lane A word, and logic-only PPA scaling
from the measured 4x12/25-bit DC result.
"""

from __future__ import annotations

import math
import re
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRAM_MD = ROOT / "main" / "sram.md"

MATRIX = 512
INPUT_BUS_LANES = 8
RESULTS_PER_WORD = 2
TARGET_PS = 1000.0
SETUP_SLACK_PS = 654.31
SHORT_PS = TARGET_PS - SETUP_SLACK_PS
FREQ_MHZ = 1000.0
ACC_BITS = 25
LATENCY_LIMIT_NS = 2_194_982.85330
POWER_LIMIT_PW = 20_000_000_000
SSE = 0.0
C0 = 1e-3

BASE_ROWS = 4
BASE_COLS = 12
BASE_PE = BASE_ROWS * BASE_COLS
BASE_AREA = 8051.540102
BASE_LOGIC_DYN_MW = 5.2498
BASE_LOGIC_LEAK_MW = 9.5191
CURRENT_SCORE = 2.211699524234e12


@dataclass(frozen=True)
class Sram:
    no: int
    words: int
    io_bits: int
    area: float
    leak_uw: float
    dyn_uw_mhz: float

    @property
    def lanes(self) -> int:
        return self.io_bits // 8


@dataclass(frozen=True)
class Candidate:
    sram: Sram
    rows: int
    cols: int
    pe: int
    banks: int
    cycles: int
    latency_ns: float
    logic_area: float
    logic_dyn_mw: float
    logic_leak_mw: float
    sram_power_mw: float
    total_power_mw: float
    score: float


def parse_sram() -> list[Sram]:
    pattern = re.compile(r"^\s*(\d+)\s+(\d+)\s+(\d+)\s+\S+\s+([0-9.]+)\s+([0-9.]+)\s+([0-9.]+)\s*$")
    specs: list[Sram] = []
    for line in SRAM_MD.read_text(encoding="utf-8").splitlines():
        match = pattern.match(line)
        if match:
            no, words, io_bits, area, leak, dyn = match.groups()
            specs.append(Sram(int(no), int(words), int(io_bits), float(area), float(leak), float(dyn)))
    return specs


def ceil_div(a: int, b: int) -> int:
    return (a + b - 1) // b


def source_words_for_tile(col_base: int, valid_cols: int) -> int:
    offset = col_base % INPUT_BUS_LANES
    return ceil_div(offset + valid_cols, INPUT_BUS_LANES)


def estimate_cycles(rows: int, cols: int) -> int:
    row_tiles = ceil_div(MATRIX, rows)
    total = 2
    col_base = 0
    while col_base < MATRIX:
        valid_cols = min(cols, MATRIX - col_base)
        b_load = MATRIX * source_words_for_tile(col_base, valid_cols) * 2
        write_cycles = rows * ceil_div(valid_cols, RESULTS_PER_WORD) * 2
        # For each 64-bit A word group: read rows from input memory (addr+capture),
        # then one B SRAM setup cycle plus 8 compute pulses.
        per_row_tile = 64 * (2 * rows + 1 + INPUT_BUS_LANES) + write_cycles + 2
        total += b_load + row_tiles * per_row_tile
        col_base += cols
    return total


def estimate(rows: int, cols: int, sram: Sram) -> Candidate | None:
    if sram.words < MATRIX:
        return None
    if sram.io_bits % 8 != 0 or sram.lanes <= 0:
        return None
    banks = ceil_div(cols, sram.lanes)
    if banks > 12:
        return None
    pe = rows * cols
    if pe > 96:
        return None
    cycles = estimate_cycles(rows, cols)
    latency_ns = cycles * SHORT_PS / 1000.0
    pe_ratio = pe / BASE_PE
    logic_area = BASE_AREA * pe_ratio
    logic_dyn = BASE_LOGIC_DYN_MW * pe_ratio
    logic_leak = BASE_LOGIC_LEAK_MW * pe_ratio
    sram_power = banks * (sram.leak_uw / 1000.0 + sram.dyn_uw_mhz * FREQ_MHZ / 1000.0)
    total_power = logic_dyn + logic_leak + sram_power
    score = math.exp(SSE / C0) * total_power * logic_area**2 * (latency_ns / 1000.0)
    return Candidate(sram, rows, cols, pe, banks, cycles, latency_ns, logic_area, logic_dyn, logic_leak, sram_power, total_power, score)


def main() -> None:
    specs = [s for s in parse_sram() if s.io_bits <= 144]
    rows_list = [2, 3, 4, 5, 6, 8, 10, 12, 16]
    cols_list = list(range(6, 25))
    candidates: list[Candidate] = []
    for rows in rows_list:
        for cols in cols_list:
            for spec in specs:
                item = estimate(rows, cols, spec)
                if item and item.latency_ns <= LATENCY_LIMIT_NS:
                    candidates.append(item)
    candidates.sort(key=lambda c: (c.total_power_mw, c.score))

    print("# Direct-A fixed-1ns ranking")
    print()
    print(f"Latency cap: <= {LATENCY_LIMIT_NS:.2f} ns, ACC_BITS={ACC_BITS}, target={TARGET_PS/1000:.3f} ns")
    print(f"Model calibration current cycles: estimated {estimate_cycles(BASE_ROWS, BASE_COLS):,}, measured 6,349,570")
    print()
    print("| Rank | No. | Word | IO | Rows | Cols | PEs | B banks | Cycles | Latency ns | Power mW | Logic area | Score | vs current score |")
    print("|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
    for rank, item in enumerate(candidates[:40], 1):
        print(
            f"| {rank} | {item.sram.no} | {item.sram.words} | {item.sram.io_bits} | "
            f"{item.rows} | {item.cols} | {item.pe} | {item.banks} | {item.cycles:,} | "
            f"{item.latency_ns:,.0f} | {item.total_power_mw:.6f} | {item.logic_area:.3f} | "
            f"{item.score:.6E} | {item.score / CURRENT_SCORE:.3f}x |"
        )

    best_score = min(candidates, key=lambda c: c.score)
    print()
    print("## Best score under latency cap")
    print(best_score)


if __name__ == "__main__":
    main()

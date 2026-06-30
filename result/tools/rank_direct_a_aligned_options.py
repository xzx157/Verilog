#!/usr/bin/env python3
"""Aligned fixed-1ns direct-A ranking.

This ranks only clean tile shapes where ROWS and COLS divide 512.  It reuses the
version-6-calibrated direct-A model and also prints what the best candidates
look like under optional PE clock-enable / operand-isolation power factors.
"""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BASE = HERE / "rank_direct_a_options.py"

spec = importlib.util.spec_from_file_location("rank_direct_a_options", BASE)
base = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = base
spec.loader.exec_module(base)

ROWS_LIST = [1, 2, 4, 8, 16]
COLS_LIST = [8, 16, 32, 64]
POWER_FACTORS = [1.00, 0.95, 0.90, 0.85]


def adjusted(item, pe_dynamic_factor: float):
    dynamic = item.logic_dyn_mw * pe_dynamic_factor
    total = dynamic + item.logic_leak_mw + item.sram_power_mw
    score = total * item.logic_area**2 * (item.latency_ns / 1000.0)
    return total, score


def main() -> None:
    specs = [s for s in base.parse_sram() if s.words >= base.MATRIX and s.io_bits <= 144]
    candidates = []
    for rows in ROWS_LIST:
        for cols in COLS_LIST:
            if base.MATRIX % rows != 0 or base.MATRIX % cols != 0:
                continue
            for sram in specs:
                item = base.estimate(rows, cols, sram)
                if item and item.latency_ns <= base.LATENCY_LIMIT_NS:
                    candidates.append(item)

    print("# Aligned direct-A fixed-1ns ranking")
    print()
    print("Constraints: ACC_BITS=25, target=1ns, ROWS|512, COLS|512, latency <= current version 6.")
    print()

    candidates.sort(key=lambda c: (c.total_power_mw, c.score))
    print("## No extra PE power reduction")
    print()
    print("| Rank | No. | Word | IO | Rows | Cols | PEs | B banks | Cycles | Latency ns | Power mW | Area | Score | vs current |")
    print("|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
    for rank, item in enumerate(candidates[:30], 1):
        print(
            f"| {rank} | {item.sram.no} | {item.sram.words} | {item.sram.io_bits} | "
            f"{item.rows} | {item.cols} | {item.pe} | {item.banks} | {item.cycles:,} | "
            f"{item.latency_ns:,.0f} | {item.total_power_mw:.6f} | {item.logic_area:.3f} | "
            f"{item.score:.6E} | {item.score / base.CURRENT_SCORE:.3f}x |"
        )

    print()
    print("## With optional PE dynamic-power reduction")
    print()
    print("The factors model clock-enable / operand-isolation savings on PE dynamic power only; leakage and SRAM power are unchanged.")
    print()
    print("| Factor | Best No. | Rows | Cols | PEs | Banks | Power mW | Score | vs current |")
    print("|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
    for factor in POWER_FACTORS:
        best = min(candidates, key=lambda c: adjusted(c, factor)[1])
        total, score = adjusted(best, factor)
        print(
            f"| {factor:.2f} | {best.sram.no} | {best.rows} | {best.cols} | {best.pe} | {best.banks} | "
            f"{total:.6f} | {score:.6E} | {score / base.CURRENT_SCORE:.3f}x |"
        )


if __name__ == "__main__":
    main()

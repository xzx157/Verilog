# Current Best Scheme

Date: 2026-06-27

## Summary

当前记录方案为固定 1 ns 口径下已完整跑通且三项目标均通过的实现点：No.36 `512x32` SRAM、`4x12` 计算阵列、25-bit signed accumulator、direct A word-buffer feeding、pipelined B SRAM reads，并在 full top 中采用 B tile reuse across row tiles。

| Item | Value |
|---|---:|
| SRAM macro | No.36, 512 words x 32-bit IO |
| Compute array | 4 x 12 |
| PE count | 48 |
| ACC_BITS | 25 |
| SRAM instances | B: 3, total: 3 |
| A feeding | Direct 64-bit word buffers |
| Target clock period | 1.000 ns |
| Cycle count | 6,349,570 |
| Shortest period | 345.69 ps |
| Latency | 2,194,982.85330 ns |
| Logic score area | 8,051.540102 um^2 |
| Total power | 15,543,079,625 pW |
| SSE | 0 |
| Score | 2.211699524234E+12 |
| Target status | SSE/latency/power pass |

## Target Status

| Metric | Target | Actual | Status |
|---|---:|---:|---|
| SSE | 0 | 0 | PASS |
| Latency | < 2,500,000 ns | 2,194,982.85330 ns | PASS, 0.88x target |
| Total power | < 20,000,000,000 pW | 15,543,079,625 pW | PASS, 0.78x target |

This is the lowest verified score so far under the fixed 1 ns clock-period rule. The previous 2 ns version is kept only as historical data and is not the current comparison baseline.

## Design Direction

The main latency and PPA reductions are:

1. A is no longer staged through an SRAM macro. The controller reads 64-bit A words and feeds eight k lanes from four row buffers directly into the PE array.
2. B uses three `512x32` SRAM banks, supporting a `4x12` PE array with alternating 64-bit input-word alignment.
3. Compute consumes one k lane per cycle after the B SRAM read setup, so each 8-lane A word group is computed without the old three-state per-k loop.
4. B tile reuse across row tiles is retained.

Traversal shape:

```text
for col tile:
  load B once
  for row tile:
    stream A word groups through direct buffers
    compute with pipelined B SRAM reads
    write valid result columns
```

## Extracted Metrics

Correctness:

```text
Correct!
>>loss is 0
>>relative_loss is 0.0
>>sse is 0.0
```

Latency evidence:

```text
[TB][LATENCY] cycles=6349570 realtime_ns=6349570.500
target clock period = 1000.00 ps
setup slack         = 654.31 ps
shortest period     = 345.69 ps
latency             = 2,194,982.85330 ns
```

Logic-only DC PPA:

```text
Number of macros/black boxes = 0
Total cell area              = 8051.540102 um^2
Dynamic power at 1 ns        = 5.2498 mW
Power frequency              = 1000.000000 MHz
Leakage power                = 9.5191 mW
Logic total power            = 14.7689 mW
```

SRAM analytical addition:

```text
SRAM instances       = 3
SRAM area total      = 493.566102 um^2, reference only
SRAM leakage total   = 0.060966 mW
SRAM dynamic total   = 0.713214 mW
SRAM total power     = 0.774180 mW
```

Final score inputs:

```text
SSE        = 0
power      = 15.543080 mW
area       = 8051.540102 um^2
latency    = 2194.98285330 us
score      = 2.211699524234E+12
```

## Validation State

Completed:

- Full remote pre-syn VCS simulation generated `result_mem.csv`.
- Local checker on fetched `result_mem.csv` passed with `SSE = 0`.
- DC synthesis completed with valid nonzero logic PPA and zero macros/black boxes.
- Post-syn VCS with SDF annotation passed: `[POST-SYN] PASS`.

Important note:

- `syn/log/constraints.rpt` still contains hold/min-delay violations; the score extraction here uses setup slack only, matching the task scoring simplification.

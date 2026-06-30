# Lab8 Result - Version 5

## Summary

Implementation point: No.36 `512x32` SRAM, `4x16` compute array, 25-bit signed accumulators, A word-unpack loading, pipelined compute SRAM reads, and B tile reuse across row tiles. The final evaluation uses a 2 ns target clock so dynamic power is evaluated at 500 MHz while the score latency still uses `cycle count x (target period - setup slack)`.

| Metric | Value |
|---|---:|
| Accuracy SSE | 0 |
| Cycle count | 6,631,426 |
| Target clock period | 2.000 ns |
| Setup slack | 1654.37 ps |
| Shortest period | 345.63 ps |
| Latency | 2,292,019.76838 ns |
| Logic score area | 10,740.056242 um^2 |
| Total power | 16.911954 mW |
| Total power | 16,911,954,375 pW |
| Score | 4.471212066210E+12 |

Target status:

| Metric | Target | Actual | Status |
|---|---:|---:|---|
| SSE | 0 | 0 | PASS |
| Latency | < 2,500,000 ns | 2,292,019.76838 ns | PASS, 0.92x target |
| Total power | < 20,000,000,000 pW | 16,911,954,375 pW | PASS, 0.85x target |

## Accuracy

The fetched full-run output `result_mem.csv` is bit-exact against the int32 golden matrix multiplication result.

```text
Correct!
>>loss is 0
>>relative_loss is 0.0
>>sse is 0.0
```

Therefore:

```text
SSE = 0
```

## Latency

Latency uses the task scoring method:

```text
latency = cycle count x shortest clock period
shortest clock period = target period - setup slack
```

Measured full pre-syn VCS marker:

```text
[TB][LATENCY] cycles=6631426 realtime_ns=13262853.000
```

Design Compiler timing:

```text
target clock period = 2000.00 ps
setup slack         = 1654.37 ps
shortest period     = 345.63 ps = 0.34563 ns
```

Final score latency:

```text
latency = 6,631,426 * 0.34563 ns
        = 2,292,019.76838 ns
        = 2.292020 ms
```

The VCS timestamp uses the 2 ns simulation clock and is retained as functional evidence. The score latency uses `cycle count x shortest period`.

## Power

The logic power is from Design Compiler `syn/log/power.rpt` for `accelerator_logic_top`. This synthesis target excludes SRAM macro instances, top controller, input memory, result memory, and data memory. The reported dynamic power is used directly at the measured 2 ns target clock; it is not scaled to the shortest feasible clock period.

```text
Measured/evaluation clock period = 2000.00 ps
Power frequency                  = 500.000000 MHz
Logic dynamic power at 2 ns      = 3.5084 mW
Logic leakage power              = 12.7076 mW
Logic total power                = 16.2160 mW
```

SRAM power is added analytically from the SRAM table for No.36:

```text
SRAM spec             = 512 words x 32-bit IO
SRAM instances        = 5 (A: 1, B: 4)
Leakage per SRAM      = 20.321875 uW
Dynamic per SRAM      = 0.237738 uW/MHz
Power frequency       = 1 / 2.000 ns = 500.000000 MHz
```

SRAM contribution:

```text
SRAM leakage total = 5 * 20.321875 uW
                   = 101.609375 uW
                   = 0.101609 mW

SRAM dynamic total = 5 * 0.237738 uW/MHz * 500.000000 MHz
                   = 594.345000 uW
                   = 0.594345 mW

SRAM total power   = 0.695954 mW
```

Final power:

```text
Total power = logic total + SRAM total
            = 16.216000 mW + 0.695954 mW
            = 16.911954 mW
            = 16,911,954,375 pW
```

## Area

The score area uses the logic-only Design Compiler report and excludes SRAM macros and excluded controller/memory blocks.

```text
Total cell area = 10,740.056242 um^2
Number of macros/black boxes = 0
```

The selected SRAM macro area is recorded for reference only:

```text
SRAM macro area per instance = 164.522034 um^2
SRAM instances              = 5
SRAM macro area total       = 822.610170 um^2
```

## Score

Using `SSE = 0`, `exp(SSE/C0) = 1`, `power = 16.911954375 mW`, `area = 10,740.056242 um^2`, and `latency = 2,292.01976838 us`:

```text
Score = exp(SSE/C0) * power(mW) * area(um^2)^2 * latency(us)
      = 4.471212066210E+12
```

## Validation

- Full pre-syn remote VCS completed and produced the latency marker.
- Local `CheckResult.py` on fetched `result_mem.csv` passed with `SSE = 0`.
- DC synthesis completed with nonzero logic area and `Number of macros/black boxes = 0`.
- Post-syn VCS with SDF annotation passed: `[POST-SYN] PASS`.
- Power uses the measured 2 ns clock frequency directly; dynamic power is not scaled by shortest period.
- DC hold/min-delay violations remain in `constraints.rpt`; the task scoring path uses setup slack only.

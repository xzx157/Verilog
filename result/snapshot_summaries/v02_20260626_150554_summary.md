# Lab8 Result

## Summary

Implementation point: No.38 `512x64` SRAM, `8x8` compute array, and 25-bit signed accumulators.

| Metric | Value |
|---|---:|
| Accuracy SSE | 0 |
| Cycle count | 40,181,762 |
| Shortest period | 345.70 ps |
| Latency | 13,890,835.1234 ns |
| Logic score area | 10,724.327603 um^2 |
| Total power | 16.632460 mW |
| Total power | 16,632,460,400 pW |
| Score | 2.657204620817E+13 |

Target status:

| Metric | Target | Actual | Status |
|---|---:|---:|---|
| SSE | 0 | 0 | PASS |
| Latency | < 2,500,000 ns | 13,890,835.1234 ns | FAIL, 5.56x target |
| Total power | < 20,000,000,000 pW | 16,632,460,400 pW | PASS, 0.83x target |

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
[TB][LATENCY] cycles=40181762 time_ns=80363525
```

Design Compiler timing:

```text
target clock period = 2000.00 ps
setup slack         = 1654.30 ps
shortest period     = 345.70 ps = 0.34570 ns
```

Final latency:

```text
latency = 40,181,762 * 0.34570 ns
        = 13,890,835.1234 ns
        = 13.890835 ms
```

The VCS timestamp uses the 2 ns simulation clock and is retained as functional evidence. The score latency uses `cycle count x shortest period`.

## Power

The logic power is from Design Compiler `syn/log/power.rpt` for `accelerator_logic_top`. This synthesis target excludes SRAM macro instances, top controller, input memory, result memory, and data/result memory. The reported dynamic power is used directly at the measured 2 ns clock; it is not scaled to the shortest feasible clock period.

```text
Measured/evaluation clock period = 2000.00 ps
Power frequency                  = 500.000000 MHz
Logic dynamic power at 2 ns      = 3.4895 mW
Logic leakage power              = 12.654900 mW
Logic total power                = 16.144400 mW
```

SRAM power is added analytically from the SRAM table for No.38:

```text
SRAM spec             = 512 words x 64-bit IO
SRAM instances        = 2
Leakage per SRAM      = 30.7342 uW
Dynamic per SRAM      = 0.426592 uW/MHz
Power frequency       = 1 / 2.000 ns = 500.000000 MHz
```

SRAM contribution:

```text
SRAM leakage total = 2 * 30.7342 uW
                   = 61.4684 uW
                   = 0.061468 mW

SRAM dynamic total = 2 * 0.426592 uW/MHz * 500.000000 MHz
                   = 426.592 uW
                   = 0.426592 mW

SRAM total power   = 0.488060 mW
```

Final power:

```text
Total power = logic total + SRAM total
            = 16.144400 mW + 0.488060 mW
            = 16.632460 mW
            = 16,632,460,400 pW
```

## Area

The score area uses the logic-only Design Compiler report and excludes SRAM macros and excluded controller/memory blocks.

```text
Total cell area = 10,724.327603 um^2
Number of macros/black boxes = 0
```

The selected SRAM macro area is recorded for reference only:

```text
SRAM macro area per instance = 294.16977 um^2
SRAM instances              = 2
SRAM macro area total       = 588.339540 um^2
```

## Score

Using `SSE = 0`, `exp(SSE/C0) = 1`, `power = 16.632460 mW`, `area = 10,724.327603 um^2`, and `latency = 13,890.8351234 us`:

```text
Score = exp(SSE/C0) * power(mW) * area(um^2)^2 * latency(us)
      = 2.657204620817E+13
```

## Validation

- Full pre-syn remote VCS completed and produced the latency marker.
- Local `CheckResult.py` on fetched `result_mem.csv` passed with `SSE = 0`.
- DC synthesis completed with nonzero logic area and `Number of macros/black boxes = 0`.
- Power uses the measured 2 ns clock frequency directly; dynamic power is not scaled by shortest period.
- Post-syn VCS with SDF annotation passed: `[POST-SYN] PASS`.
- DC hold/min-delay violations remain in `constraints.rpt`; the task scoring path uses setup slack only.
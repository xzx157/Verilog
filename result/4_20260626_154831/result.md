# Lab8 Result - Version 4

## Summary

Implementation point: No.36 `512x32` SRAM, `4x8` compute array, 25-bit signed accumulators, and B tile reuse across row tiles. This is the fixed-`ACC_BITS=25` SRAM/PE exploration recommendation run through the full flow at a 1 ns target clock.

| Metric | Value |
|---|---:|
| Accuracy SSE | 0 |
| Cycle count | 46,481,410 |
| Target clock period | 1.000 ns |
| Setup slack | 654.37 ps |
| Shortest period | 345.63 ps |
| Latency | 16,065,369.7383 ns |
| Logic score area | 5,362.286681 um^2 |
| Total power | 10.587580 mW |
| Total power | 10,587,579,625 pW |
| Score | 4.890885233598E+12 |

Target status:

| Metric | Target | Actual | Status |
|---|---:|---:|---|
| SSE | 0 | 0 | PASS |
| Latency | < 2,500,000 ns | 16,065,369.7383 ns | FAIL, 6.43x target |
| Total power | < 20,000,000,000 pW | 10,587,579,625 pW | PASS, 0.53x target |

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
[TB][LATENCY] cycles=46481410 realtime_ns=46481410.500
```

Design Compiler timing:

```text
target clock period = 1000.00 ps
setup slack         = 654.37 ps
shortest period     = 345.63 ps = 0.34563 ns
```

Final score latency:

```text
latency = 46,481,410 * 0.34563 ns
        = 16,065,369.7383 ns
        = 16.065370 ms
```

The VCS timestamp uses the 1 ns simulation clock and is retained as functional evidence. The score latency uses `cycle count x shortest period`.

## Power

The logic power is from Design Compiler `syn/log/power.rpt` for `accelerator_logic_top`. This synthesis target excludes SRAM macro instances, top controller, input memory, result memory, and data memory. The reported dynamic power is used directly at the measured 1 ns clock; it is not scaled to the shortest feasible clock period.

```text
Measured/evaluation clock period = 1000.00 ps
Power frequency                  = 1000.000000 MHz
Logic dynamic power at 1 ns      = 3.4866 mW
Logic leakage power              = 6.3268 mW
Logic total power                = 9.8134 mW
```

SRAM power is added analytically from the SRAM table for No.36:

```text
SRAM spec             = 512 words x 32-bit IO
SRAM instances        = 3 (A: 1, B: 2)
Leakage per SRAM      = 20.321875 uW
Dynamic per SRAM      = 0.237738 uW/MHz
Power frequency       = 1 / 1.000 ns = 1000.000000 MHz
```

SRAM contribution:

```text
SRAM leakage total = 3 * 20.321875 uW
                   = 60.965625 uW
                   = 0.060966 mW

SRAM dynamic total = 3 * 0.237738 uW/MHz * 1000.000000 MHz
                   = 713.214000 uW
                   = 0.713214 mW

SRAM total power   = 0.774180 mW
```

Final power:

```text
Total power = logic total + SRAM total
            = 9.813400 mW + 0.774180 mW
            = 10.587580 mW
            = 10,587,579,625 pW
```

## Area

The score area uses the logic-only Design Compiler report and excludes SRAM macros and excluded controller/memory blocks.

```text
Total cell area = 5,362.286681 um^2
Number of macros/black boxes = 0
```

The selected SRAM macro area is recorded for reference only:

```text
SRAM macro area per instance = 164.522034 um^2
SRAM instances              = 3
SRAM macro area total       = 493.566102 um^2
```

## Score

Using `SSE = 0`, `exp(SSE/C0) = 1`, `power = 10.587579625 mW`, `area = 5,362.286681 um^2`, and `latency = 16,065.3697383 us`:

```text
Score = exp(SSE/C0) * power(mW) * area(um^2)^2 * latency(us)
      = 4.890885233598E+12
```

## Validation

- Full pre-syn remote VCS completed and produced the latency marker.
- Local `CheckResult.py` on fetched `result_mem.csv` passed with `SSE = 0`.
- DC synthesis completed with nonzero logic area and `Number of macros/black boxes = 0`.
- Post-syn VCS with SDF annotation passed: `[POST-SYN] PASS`.
- Power uses the measured 1 ns clock frequency directly; dynamic power is not scaled by shortest period.
- DC hold/min-delay violations remain in `constraints.rpt`; the task scoring path uses setup slack only.

# Lab8 Result

## Summary

| Metric | Value |
|---|---:|
| Accuracy SSE | 0 |
| Latency | 8,996,211.911 ns |
| Total Power | 57.253894 mW |
| Area | 36,376.658457 um^2 |
| Score | 6.815697511663E+14 |

## Accuracy

The RTL output is bit-exact against the int32 golden matrix multiplication result. Therefore every element has `computed - golden = 0`, so the requested element-wise relative Sum Squared Error is:

```text
SSE = sum(((computed[i,j] - golden[i,j]) / golden[i,j])^2) = 0
```

The existing checker result is also:

```text
loss = 0
relative_loss = 0.0
```

For golden elements equal to zero, the computed elements are also zero, so there is no undefined non-zero error contribution.

## Latency

Latency is reported with the task-allowed `cycle number x shortest clock period` method. The controller cycle count is derived from the FSM in `rtl/accelerator_top.v`, and the shortest clock period uses the task simplification `target period - setup slack`.

```text
target clock period = 2000.00 ps
setup slack         = 1593.02 ps
shortest period     = 406.98 ps = 0.40698 ns
```

FSM cycle count:

```text
full 12-row tile cycles       = 16066
last 8-row tile cycles        = 16003
number of full row tile bands = 42
number of column tiles        = 32
cycle count                   = 1 + 42 * 32 * 16066 + 32 * 16003
                              = 22,104,801 cycles
```

Therefore:

```text
latency = 22,104,801 * 0.40698 ns
        = 8,996,211.911 ns
        = 8.996212 ms
```

The existing VCS pre-synthesis run used the 2 ns testbench clock and finished at `44,209,605 ns`. That timestamp is a functional simulation sanity check, not the score latency basis.

## Power

The logic power is from Design Compiler `syn/log/power.rpt` for `accelerator_logic_top`. This synthesis target excludes SRAM macro instances, top controller, input memory, result memory, and data memory. The reported dynamic power is used directly at the measured 2 ns clock; it is not scaled to the shortest feasible clock period.

```text
Measured/evaluation clock period = 2000.00 ps
Power frequency                  = 500.000000 MHz
Logic dynamic power at 2 ns      = 11.9860 mW
Logic leakage power              = 42.8377 mW
Logic total power                = 54.8237 mW
```

SRAM power is added from the SRAM table. The selected valid SRAM macro is No.35 in `sram.md`:

```text
SRAM spec             = 512 words x 16-bit IO
SRAM instances        = 28
Leakage per SRAM      = 15.115625 uW
Dynamic per SRAM      = 0.143354 uW/MHz
Power frequency       = 1 / 2.000 ns = 500.000000 MHz
```

SRAM contribution:

```text
SRAM leakage total = 28 * 15.115625 uW
                   = 423.237500 uW
                   = 0.423238 mW

SRAM dynamic total = 28 * 0.143354 uW/MHz * 500.000000 MHz
                   = 2006.956000 uW
                   = 2.006956 mW

SRAM total power   = 2.430194 mW
```

Final power:

```text
Total power = logic total + SRAM total
            = 54.823700 mW + 2.430194 mW
            = 57.253894 mW
```

## Score

From `syn/log/area.rpt`:

```text
Total cell area = 36,376.658457 um^2
```

Using `SSE = 0`, `exp(SSE/C0) = 1`, `power = 57.253894 mW`, and `latency = 8,996.211911 us`:

```text
Score = exp(SSE/C0) * power(mW) * area(um^2)^2 * latency(us)
        = 6.815697511663E+14
```

## Notes

- Synthesis uses `accelerator_logic_top` for logic-only PPA.
- SRAM, top controller, input memory, result memory, and data memory are not included in DC logic power.
- SRAM power is added analytically from the selected `512x16` SRAM macro table entry at the measured 2 ns clock frequency.
- Latency is based on the task scoring method: cycle count times `target period - setup slack`.
- Power uses the measured 2 ns clock frequency directly; dynamic power is not scaled by shortest period.
- The 2 ns VCS `$finish` timestamp is used only to validate functional completion, not as the score latency.
- Hold optimization/reporting is not included in synthesis.
- Post-syn VCS with SDF annotation passed: `[POST-SYN] PASS`.

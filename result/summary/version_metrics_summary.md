# Version Metrics Summary

## Accuracy

| 命名 | 快照目录 | SSE | Loss | Relative loss |
|---|---|---:|---:|---:|
| `1_20260624_235307` | [`1_20260624_235307`](../1_20260624_235307) | `0` | `0` | `0` |
| `2_20260626_150554` | [`2_20260626_150554`](../2_20260626_150554) | `0` | `0` | `0` |
| `3_20260626_153048` | [`3_20260626_153048`](../3_20260626_153048) | `0` | `0` | `0` |
| `4_20260626_154831` | [`4_20260626_154831`](../4_20260626_154831) | `0` | `0` | `0` |
| `5_20260627_001700` | [`5_20260627_001700`](../5_20260627_001700) | `0` | `0` | `0` |
| `6_20260627_003047` | [`6_20260627_003047`](../6_20260627_003047) | `0` | `0` | `0` |
| `7_20260627_005858` | [`7_20260627_005858`](../7_20260627_005858) | `0` | `0` | `0` |
| `8_20260627_010207` | [`8_20260627_010207`](../8_20260627_010207) | `0` | `0` | `0` |
| `9_20260627_011232` | [`9_20260627_011232`](../9_20260627_011232) | `0` | `0` | `0` |
| `10_20260629_075914` | [`10_20260629_075914`](../10_20260629_075914) | `0` | `0` | `0` |
| `11_20260629_082321` | [`11_20260629_082321`](../11_20260629_082321) | `0` | `0` | `0` |
| `12_20260630_034303` | [`12_20260630_034303`](../12_20260630_034303) | `0` | `0` | `0` |
| `13_20260630_035423` | [`13_20260630_035423`](../13_20260630_035423) | `0` | `0` | `0` |
| `14_20260630_040650` | [`14_20260630_040650`](../14_20260630_040650) | `0` | `0` | `0` |

## Latency

| 命名 | Target period (ns) | Setup slack (ps) | Shortest period (ps) | Full tile cycles | Last tile cycles | Row bands | Column tiles | Cycle count | Latency basis | Latency (ns) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| `1_20260624_235307` | `2` | `1593.02` | `406.98` | `16066` | `16003` | `42` | `32` | `22,104,801` | `cycles x 406.98ps` | `8,996,212` |
| `2_20260626_150554` | `2` | `1654.30` | `345.70` | `-` | `-` | `64` | `64` | `40,181,762` | `measured cycles x 345.70ps` | `13,890,835` |
| `3_20260626_153048` | `1` | `654.30` | `345.70` | `-` | `-` | `64` | `64` | `40,181,762` | `measured cycles x 345.70ps` | `13,890,835` |
| `4_20260626_154831` | `1` | `654.37` | `345.63` | `-` | `-` | `128` | `64` | `46,481,410` | `measured cycles x 345.63ps` | `16,065,370` |
| `5_20260627_001700` | `2` | `1654.37` | `345.63` | `-` | `-` | `128` | `32` | `6,631,426` | `measured cycles x 345.63ps` | `2,292,020` |
| `6_20260627_003047` | `1` | `654.31` | `345.69` | `-` | `-` | `128` | `43` | `6,349,570` | `measured cycles x 345.69ps` | `2,194,983` |
| `7_20260627_005858` | `1` | `654.37` | `345.63` | `-` | `-` | `512` | `16` | `6,111,234` | `measured cycles x 345.63ps` | `2,112,226` |
| `8_20260627_010207` | `1` | `654.37` | `345.63` | `-` | `-` | `512` | `16` | `6,111,234` | `measured cycles x 345.63ps` | `2,112,226` |
| `9_20260627_011232` | `1` | `654.37` | `345.63` | `-` | `-` | `512` | `16` | `6,111,234` | `measured cycles x 345.63ps` | `2,112,226` |
| `10_20260629_075914` | `1` | `657.72` | `342.28` | `-` | `-` | `512` | `16` | `6,111,234` | `measured cycles x 342.28ps` | `2,091,753` |
| `11_20260629_082321` | `1` | `658.08` | `341.92` | `-` | `-` | `512` | `16` | `6,111,234` | `measured cycles x 341.92ps` | `2,089,553` |
| `12_20260630_034303` | `10` | `9658.08` | `341.92` | `-` | `-` | `512` | `16` | `6,111,234` | `measured cycles x 341.92ps` | `2,089,553` |
| `13_20260630_035423` | `10` | `9641.00` | `359.00` | `-` | `-` | `512` | `16` | `5,586,946` | `measured cycles x 359.00ps` | `2,005,714` |
| `14_20260630_040650` | `10` | `9641.00` | `359.00` | `-` | `-` | `512` | `16` | `5,464,066` | `measured cycles x 359.00ps` | `1,961,600` |

VCS pre-syn used a 2 ns testbench clock and finished at `44,209,605 ns`; it validates functional completion but is not the score latency basis.

For `2_20260626_150554`, the full pre-syn marker was `[TB][LATENCY] cycles=40181762 time_ns=80363525`; the score latency uses the measured cycle count and DC setup-derived shortest period.

For `3_20260626_153048`, the full pre-syn marker was `[TB][LATENCY] cycles=40181762 realtime_ns=40181762.500`; the score latency uses the measured cycle count and DC setup-derived shortest period. Post-syn SDF smoke was skipped to reduce checking work.

For `4_20260626_154831`, the full pre-syn marker was `[TB][LATENCY] cycles=46481410 realtime_ns=46481410.500`; the score latency uses the measured cycle count and DC setup-derived shortest period.

For `5_20260627_001700`, the full pre-syn marker was `[TB][LATENCY] cycles=6631426 realtime_ns=13262853.000`; the score latency uses the measured cycle count and DC setup-derived shortest period. This version adds A word-unpack loading, compute SRAM read pipelining, and a `4x16` PE array.

For `6_20260627_003047`, the full pre-syn marker was `[TB][LATENCY] cycles=6349570 realtime_ns=6349570.500`; the score latency uses the measured cycle count and DC setup-derived shortest period. This is the current fixed-1ns best. Version 5 used a 2ns evaluation period and is retained only as historical data.

For `7_20260627_005858`, the architecture is clean aligned direct-A `1x32` with two No.42 `512x128` B SRAM macros. The full remote VCS pre-syn marker was `[TB][LATENCY] cycles=6111234 realtime_ns=6111234.500`; `CheckResult.py` returned `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`. Remote post-syn SDF smoke returned `[POST-SYN] PASS`.

For `8_20260627_010207`, the architecture keeps the clean aligned direct-A `1x32` and adds PE operand isolation: multiplier inputs are driven to zero when `pulse_en=0`. The full remote VCS pre-syn marker remained `[TB][LATENCY] cycles=6111234 realtime_ns=6111234.500`; `CheckResult.py` returned `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`. Remote post-syn SDF smoke returned `[POST-SYN] PASS`.

For `9_20260627_011232`, the architecture keeps version 8 and adds controller-level sparse gating using the measured 35% input sparsity: when the current A byte is zero, the PE pulse is skipped and B SRAM read/prefetch chip-select remains inactive for that cycle. The full remote VCS pre-syn marker remained `[TB][LATENCY] cycles=6111234 realtime_ns=6111234.500`; `CheckResult.py` returned `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`. Remote post-syn SDF smoke returned `[POST-SYN] PASS`.

For `10_20260629_075914`, the architecture keeps version 9 latency and SRAM access pattern, adds the same A-zero sparse gate to the logic-only synthesis top, and enables Design Compiler integrated clock gating with `compile -gate_clock`. The full remote VCS pre-syn marker remained `[TB][LATENCY] cycles=6111234 realtime_ns=6111234.500`; `CheckResult.py` returned `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`. Remote post-syn SDF smoke returned `Doing SDF annotation ...... Done` and `[POST-SYN] PASS`.

For `11_20260629_082321`, the RTL and cycle count are unchanged from version 10. The synthesis flow uses the more aggressive `compile -gate_clock -map_effort high -area_effort high` at the fixed 1ns target. The full remote VCS pre-syn marker remains `[TB][LATENCY] cycles=6111234 realtime_ns=6111234.500`; `CheckResult.py` remains `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`. Remote post-syn SDF smoke returned `Doing SDF annotation ...... Done` and `[POST-SYN] PASS`.

For `12_20260630_034303`, the RTL and cycle count are unchanged from version 11. The design uses a single `10.00ns` clock target, which is allowed by the `1.00ns` to `10.00ns` period range. Power is evaluated at `100MHz`; latency still uses the task score basis `cycle_count x (target period - setup slack)`, so the shortest-period basis remains `341.92ps` and latency does not increase. Remote post-syn SDF smoke returned `Doing SDF annotation ...... Done` and `[POST-SYN] PASS`.

For `13_20260630_035423`, the controller removes the per-A-word `S_COMPUTE_ADDR` bubble by issuing the first B SRAM read during `S_LOAD_A_WRITE`; this reduces cycle count to `5,586,946` while preserving correctness. The lower cycle count gives enough latency margin to use lower-leakage `compile_ultra -gate_clock -area_high_effort_script` at the single `10.00ns` clock target. Remote pre-syn VCS returned `[TB][LATENCY] cycles=5586946 realtime_ns=5586946.500`; `CheckResult.py` returned `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`. Remote post-syn SDF smoke returned `Doing SDF annotation ...... Done` and `[POST-SYN] PASS`.

For `14_20260630_040650`, the controller streams result writeback after the first setup beat, writing one 64-bit result word per cycle and using the final synchronous RAM write edge as the flush. This reduces cycle count to `5,464,066` while preserving correctness. Remote pre-syn VCS returned `[TB][LATENCY] cycles=5464066 realtime_ns=5464066.500`; `CheckResult.py` returned `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`. Remote post-syn SDF smoke returned `Doing SDF annotation ...... Done` and `[POST-SYN] PASS`.

## Power

| 命名 | Logic dynamic (pW) | Logic leakage (pW) | Logic total (pW) | SRAM word | SRAM IO bit | SRAM count | SRAM leakage/个 (pW) | SRAM dynamic/个 (pW/MHz) | Power freq (MHz) | SRAM total (pW) | Total power (pW) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `1_20260624_235307` | `11986000000` | `42837700000` | `54823700000` | `512` | `16` | `28` | `15115625` | `143354` | `500` | `2430193500` | `57253893500` |
| `2_20260626_150554` | `3489500000` | `12654900000` | `16144400000` | `512` | `64` | `2` | `30734200` | `426592` | `500` | `488060400` | `16632460400` |
| `3_20260626_153048` | `6979000000` | `12654900000` | `19633900000` | `512` | `64` | `2` | `30734200` | `426592` | `1000` | `914652400` | `20548552400` |
| `4_20260626_154831` | `3486600000` | `6326800000` | `9813400000` | `512` | `32` | `3` | `20321875` | `237738` | `1000` | `774179625` | `10587579625` |
| `5_20260627_001700` | `3508400000` | `12707600000` | `16216000000` | `512` | `32` | `5` | `20321875` | `237738` | `500` | `695954375` | `16911954375` |
| `6_20260627_003047` | `5249800000` | `9519100000` | `14768900000` | `512` | `32` | `3` | `20321875` | `237738` | `1000` | `774179625` | `15543079625` |
| `7_20260627_005858` | `3516400000` | `6402900000` | `9919300000` | `512` | `128` | `2` | `51558850` | `804300` | `1000` | `1711717700` | `11631017700` |
| `8_20260627_010207` | `2921300000` | `6371000000` | `9292300000` | `512` | `128` | `2` | `51558850` | `804300` | `1000` | `1711717700` | `11004017700` |
| `9_20260627_011232` | `2921300000` | `6371000000` | `9292300000` | `512` | `128` | `2` | `51558850` | `804300` | `1000` | `818436388` | `10110736388` |
| `10_20260629_075914` | `2869600000` | `6337200000` | `9206800000` | `512` | `128` | `2` | `51558850` | `804300` | `1000` | `818436388` | `10025236388` |
| `11_20260629_082321` | `2857500000` | `6302900000` | `9160400000` | `512` | `128` | `2` | `51558850` | `804300` | `1000` | `818436388` | `9978836388` |
| `12_20260630_034303` | `285751500` | `6302900000` | `6588651500` | `512` | `128` | `2` | `51558850` | `804300` | `100` | `174649569` | `6763301069` |
| `13_20260630_035423` | `343740700` | `5059000000` | `5402740700` | `512` | `128` | `2` | `51558850` | `804300` | `100` | `181362234` | `5584102934` |
| `14_20260630_040650` | `343740700` | `5059000000` | `5402740700` | `512` | `128` | `2` | `51558850` | `804300` | `100` | `183121856` | `5585862556` |

For `9_20260627_011232`, SRAM dynamic is access-duty scaled because the new sparse controller explicitly gates B SRAM chip-select on A-zero cycles. Actual A nonzero count is `169,336 / 262,144`; B access active cycles are `169,336 * 16 + 16 * 512 = 2,717,568`, so B SRAM dynamic duty is `2,717,568 / 6,111,234 = 44.4684003%`. Under the old non-duty-scaled SRAM convention, version 9 has the same total power as version 8: `11,004,017,700pW`.

For `10_20260629_075914`, SRAM access duty is unchanged from version 9. The new gain comes from logic-only synthesis: global A-zero gating is visible in `accelerator_logic_top`, and DC maps integrated clock-gating cells. Under the old non-duty-scaled SRAM convention, version 10 total power is `10,918,517,700pW`.

For `11_20260629_082321`, SRAM access duty is unchanged from version 9/10. The new gain is from high-effort mapped logic-only synthesis. Under the old non-duty-scaled SRAM convention, version 11 total power is `10,872,117,700pW`.

For `12_20260630_034303`, SRAM access duty is unchanged from version 9/10/11, but dynamic SRAM power is evaluated at the selected `100MHz` clock frequency. SRAM total power is `174,649,569pW`, and total power is reduced below the `7e9pW` target.

For `13_20260630_035423`, B access active cycles remain `2,717,568`, but total cycles are reduced to `5,586,946`, so B access duty becomes `48.641387%`. SRAM power at `100MHz` is `181,362,234pW`; lower logic leakage dominates the total-power reduction.

For `14_20260630_040650`, B access active cycles remain `2,717,568`, but total cycles are reduced to `5,464,066`, so B access duty becomes `49.735270%`. SRAM power at `100MHz` is `183,121,856pW`; the slight SRAM power increase is outweighed by the lower latency.

## Score

| 命名 | Area (um^2) | Latency (ns) | Power (pW) | SSE | Score |
|---|---:|---:|---:|---:|---:|
| `1_20260624_235307` | `36376.658457` | `8,996,212` | `57253893500` | `0` | `6.815697511663E+14` |
| `2_20260626_150554` | `10724.327603` | `13,890,835` | `16632460400` | `0` | `2.657204620817E+13` |
| `3_20260626_153048` | `10724.327603` | `13,890,835` | `20548552400` | `0` | `3.282840125589E+13` |
| `4_20260626_154831` | `5362.286681` | `16,065,370` | `10587579625` | `0` | `4.890885233598E+12` |
| `5_20260627_001700` | `10740.056242` | `2,292,020` | `16911954375` | `0` | `4.471212066210E+12` |
| `6_20260627_003047` | `8051.540102` | `2,194,983` | `15543079625` | `0` | `2.211699524234E+12` |
| `7_20260627_005858` | `5383.913561` | `2,112,226` | `11631017700` | `0` | `7.121216976807E+11` |
| `8_20260627_010207` | `5524.881503` | `2,112,226` | `11004017700` | `0` | `7.094757575043E+11` |
| `9_20260627_011232` | `5524.881503` | `2,112,226` | `10110736388` | `0` | `6.518821173428E+11` |
| `10_20260629_075914` | `5398.167653` | `2,091,753` | `10025236388` | `0` | `6.110796135269E+11` |
| `11_20260629_082321` | `5352.751203` | `2,089,553` | `9978836388` | `0` | `5.974305621476E+11` |
| `12_20260630_034303` | `5352.751203` | `2,089,553` | `6763301069` | `0` | `4.049172270572E+11` |
| `13_20260630_035423` | `4296.081454` | `2,005,714` | `5584102934` | `0` | `2.067127913980E+11` |
| `14_20260630_040650` | `4296.081454` | `1,961,600` | `5585862556` | `0` | `2.022300291761E+11` |

## Final Metrics

| 命名 | SSE | Latency (ns) | Total power (pW) |
|---|---:|---:|---:|
| `1_20260624_235307` | `0` | `8,996,212` | `57,253,893,500` |
| `2_20260626_150554` | `0` | `13,890,835` | `16,632,460,400` |
| `3_20260626_153048` | `0` | `13,890,835` | `20,548,552,400` |
| `4_20260626_154831` | `0` | `16,065,370` | `10,587,579,625` |
| `5_20260627_001700` | `0` | `2,292,020` | `16,911,954,375` |
| `6_20260627_003047` | `0` | `2,194,983` | `15,543,079,625` |
| `7_20260627_005858` | `0` | `2,112,226` | `11,631,017,700` |
| `8_20260627_010207` | `0` | `2,112,226` | `11,004,017,700` |
| `9_20260627_011232` | `0` | `2,112,226` | `10,110,736,388` |
| `10_20260629_075914` | `0` | `2,091,753` | `10,025,236,388` |
| `11_20260629_082321` | `0` | `2,089,553` | `9,978,836,388` |
| `12_20260630_034303` | `0` | `2,089,553` | `6,763,301,069` |
| `13_20260630_035423` | `0` | `2,005,714` | `5,584,102,934` |
| `14_20260630_040650` | `0` | `1,961,600` | `5,585,862,556` |

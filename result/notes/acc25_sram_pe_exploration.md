# ACC_BITS=25 SRAM/PE Exploration

Date: 2026-06-26

## Scope

固定中间累加位宽为 25-bit signed integer，枚举 `sram.md` 中可用 SRAM macro 和 `A_ROWS x B_COLS` PE 阵列规模。

主要报告文件：

- `rankings/sram_candidates_acc25_1ns.md`: 1 ns 目标周期，按 target-score 排序。
- `rankings/sram_candidates_acc25_1ns_with_score.md`: 1 ns 目标周期，按 score 排序。
- `rankings/sram_candidates_acc25.md`: 2 ns 目标周期，按 target-score 排序。
- `rankings/sram_candidates_acc25_with_score.md`: 2 ns 目标周期，按 score 排序。

当前更贴近第三版实验的是 1 ns 口径：`target_period = 1000 ps`，`setup_slack = 654.30 ps`，因此 `shortest_period = 345.70 ps`；power 按 measured frequency `1000 MHz` 计算，不按 shortest period 缩放。

## 1 ns Result

固定 `ACC_BITS=25` 后，共枚举 `982` 个候选。没有候选同时满足：

```text
power < 2e10 pW
latency < 2.5e6 ns
```

### Best By Score

按 Lab8 score 最低排序，最佳候选是：

| Item | Value |
|---|---:|
| SRAM macro | No.27, 256 words x 32-bit IO |
| PE array | 4 x 8 |
| PE count | 32 |
| ACC_BITS | 25 |
| SRAM A+B | 1 + 2 |
| K chunk | 256 x 2 |
| Capacity utilization | 100.0% |
| Lane utilization | 100.0% |
| Estimated cycles | 21,626,881 |
| Estimated latency | 7,476,413 ns |
| Estimated power | 18,187,435,800 pW |
| Estimated logic area | 11,595.1 um^2 |
| Estimated score | 1.828145E+13 |

This candidate passes the power target in the estimator, but misses the latency target by about `2.99x`.

### Near-Equivalent Score Candidate

No.36 is almost tied with No.27:

| Item | Value |
|---|---:|
| SRAM macro | No.36, 512 words x 32-bit IO |
| PE array | 4 x 8 |
| PE count | 32 |
| SRAM A+B | 1 + 2 |
| K chunk | 512 x 1 |
| Estimated cycles | 21,561,345 |
| Estimated latency | 7,453,757 ns |
| Estimated power | 18,249,234,000 pW |
| Estimated score | 1.828799E+13 |

No.36 has slightly worse score than No.27, but it is simpler because `K_chunk = 512 x 1` avoids multi-chunk accumulation across K. For RTL implementation risk, No.36 may be the more practical next experiment.

### Best Latency Under Power Target

The best latency candidate that still passes power is also No.36 `512x32` with `4x8` array:

```text
latency = 7,453,757 ns
power   = 18,249,234,000 pW
score   = 1.828799E+13
```

### Best Power Among Latency-Passing Candidates

If latency target is prioritized, the lowest-power latency-passing candidate is:

| Item | Value |
|---|---:|
| SRAM macro | No.3, 32 words x 64-bit IO |
| PE array | 8 x 16 |
| PE count | 128 |
| SRAM A+B | 1 + 2 |
| K chunk | 32 x 16 |
| Estimated latency | 2,027,694 ns |
| Estimated power | 38,067,831,600 pW |
| Estimated score | 4.653864E+13 |

This candidate passes latency but misses power by about `1.90x`, so it is not attractive under the current power target.

## Comparison To Current Verified Design

Current verified design point:

```text
No.38 512x64 SRAM, 8x8 PE array, ACC_BITS=25
```

In the 1 ns estimator table, that configuration appears as:

| Item | Value |
|---|---:|
| Estimated rank by score | 16 |
| Estimated cycles | 10,911,745 |
| Estimated latency | 3,772,190 ns |
| Estimated power | 24,900,021,150 pW |
| Estimated score | 2.379003E+13 |

The real third-version run for this same design measured:

```text
cycle count = 40,181,762
latency     = 13,890,835.1234 ns
power       = 20,548,552,400 pW
score       = 3.282840125589E+13
```

The estimator is useful for ranking, but it underestimates full-controller cycles for the current `8x8/512x64` implementation. Any selected candidate still needs a real RTL run before replacing the current best record.

## Recommendation

Best next RTL experiment:

```text
SRAM: No.36, 512 words x 32-bit IO
PE array: 4 x 8
ACC_BITS: 25
SRAM instances: A 1 + B 2
```

Reason:

- It is nearly tied with the estimated score winner No.27.
- It is the lowest-latency candidate that stays under the power target in the estimator.
- `K_chunk = 512 x 1` is simpler than No.27's `256 x 2` K chunking.
- It reduces PE count from 64 to 32, which should reduce logic power and area.

Risk:

- The estimator predicts latency still misses the `2.5e6 ns` target.
- The controller-cycle model has known mismatch versus the current measured `8x8/512x64` implementation, so real latency must be measured after RTL changes.
# rankings 目录说明

本目录保存优化过程中生成的候选参数排行表。它们用于比较 SRAM 选型、PE 阵列规模和 direct-A 结构在不同口径下的面积、功耗、延迟或 score。

## 文件说明

- `sram_candidates_baseline.md`：早期 SRAM/PE 候选组合的基线排行表。
- `sram_candidates_acc25.md`：固定累加位宽为 25 bit、2 ns 目标周期口径下，按 target-score 排序的 SRAM/PE 候选表。
- `sram_candidates_acc25_with_score.md`：固定累加位宽为 25 bit、2 ns 目标周期口径下，按 score 排序的候选表。
- `sram_candidates_acc25_1ns.md`：固定累加位宽为 25 bit、1 ns 目标周期口径下，按 target-score 排序的候选表。
- `sram_candidates_acc25_1ns_with_score.md`：固定累加位宽为 25 bit、1 ns 目标周期口径下，按 score 排序的候选表。
- `direct_a_1ns_ranking.md`：direct-A 结构候选在 1 ns 口径下的排行表。
- `direct_a_aligned_1ns_ranking.md`：aligned direct-A 结构候选在 1 ns 口径下的排行表，是后续选择 `1x32` 架构的重要参考。
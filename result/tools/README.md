# tools 目录说明

本目录保存生成候选排行表时使用的小脚本。这些脚本不是最终提交代码，只用于历史探索和结果复现。

## 文件说明

- `evaluate_sram_options.py`：枚举 SRAM macro 和 PE 阵列规模，估算候选结构的面积、功耗、延迟等指标。
- `rank_direct_a_options.py`：生成 direct-A 结构候选排行，用于比较不同 tile/PE 配置。
- `rank_direct_a_aligned_options.py`：生成 aligned direct-A 结构候选排行，用于比较对齐后的 direct-A 数据流和 B SRAM 组织方式。
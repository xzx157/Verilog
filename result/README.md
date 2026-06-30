# Lab8 结果归档

这个目录保存 Lab8 优化过程中的历史结果。顶层的 `1_...` 到 `14_...` 是版本快照目录，保持原名不动，方便和时间戳、历史记录对应。

## 目录说明

- `1_20260624_235307` ... `14_20260630_040650`：各版本完整快照，保留当次代码、日志、数据和报告。
- `summary/`：总览和最终方案记录。
  - `version_metrics_summary.md`：各版本 SSE、latency、power 和历史 score 对比表。
  - `final_selected_scheme.md`：最终选定方案说明。
  - `optimization_history.md`：优化流程和迭代记录。
- `snapshot_summaries/`：早期快照的单独结果摘要副本，按 `vXX_timestamp_summary.md` 命名。
- `rankings/`：SRAM 和 direct-A 参数候选排行表。
- `notes/`：不属于单个快照的探索笔记。
- `tools/`：生成 ranking 表的小脚本。

## 最终版本

最终选定快照是 `14_20260630_040650`。正式提交包单独放在 `../submit`。
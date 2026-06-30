# 快照 9：20260627_011232

本目录是 Lab8 第 9 版实验结果快照。该版本在第 8 版基础上加入 controller 级 A-zero 稀疏门控，当当前 A byte 为 0 时跳过 PE pulse，并关闭对应 B SRAM read/prefetch chip-select。

## 版本要点

- direct-A `1x32` 结构保持不变
- 新增 controller-level sparse gating
- B SRAM 动态功耗开始按有效访问 duty 统计
- pre-syn VCS 周期数：`6,111,234`
- checker：`sse=0.0`
- post-syn SDF：PASS

## 文件说明

- `README.md`：本文件，说明该快照内容。
- `InputGen.py`：生成输入数据 `input_mem.csv` 和 `in.npy`。
- `CheckResult.py`：检查 `result_mem.csv` 是否与 Python 参考矩阵乘结果一致。
- `input_mem.csv`：该快照使用的输入 memory 内容。
- `result_mem.csv`：该快照仿真得到的输出 memory 内容。
- `in.npy`：NumPy 保存的原始输入矩阵。
- `Makefile`：该快照的顶层运行入口。
- `sram.md`：SRAM macro 参数表。

## 子目录说明

- `rtl/`：该版本 RTL 源码。
- `syn/`：综合脚本、PPA 报告、门级网表和 SDF。
- `testbench/`：pre-syn/post-syn testbench 与公共 memory 模型。
- `remote_logs/`：远端仿真、综合、检查时保存的日志。

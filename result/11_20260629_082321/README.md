# 快照 11：20260629_082321

本目录是 Lab8 第 11 版实验结果快照。该版本 RTL 和周期数与第 10 版一致，主要调整综合策略，使用更高 effort 的 gate-clock/area 优化流程以进一步降低功耗和面积。

## 版本要点

- RTL 周期数保持 `6,111,234`
- 综合策略更偏高 effort 映射和面积优化
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

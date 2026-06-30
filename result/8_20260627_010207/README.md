# 快照 8：20260627_010207

本目录是 Lab8 第 8 版实验结果快照。该版本在第 7 版 aligned direct-A `1x32` 架构基础上加入 PE 操作数隔离，在无效 pulse 时关闭乘法器输入切换。

## 版本要点

- 保持 direct-A `1x32` 结构和两个 No.42 `512x128` B SRAM bank
- 新增 PE operand isolation，降低无效周期动态功耗
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

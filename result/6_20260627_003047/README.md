# 快照 6：20260627_003047

本目录是 Lab8 第 6 版实验结果快照，用于保留当时的代码、输入输出数据、综合报告和验证记录。

## 文件说明

- `result.md`：该版本的结果摘要，记录正确性、延迟、功耗、面积等指标。
- `InputGen.py`：生成 `input_mem.csv` 和 `in.npy` 的输入数据脚本。
- `CheckResult.py`：读取 `result_mem.csv` 并和 Python 参考矩阵乘结果比较的检查脚本。
- `input_mem.csv`：该版本使用的输入 memory 内容。
- `result_mem.csv`：该版本 Verilog 仿真得到的输出 memory 内容。
- `in.npy`：NumPy 保存的原始输入矩阵，用于 checker 复现参考结果。
- `Makefile`：该快照的顶层运行入口。
- `sram.md`：SRAM macro 参数表。

## 子目录说明

- `rtl/`：该版本 RTL 源码，包括加速器顶层、计算阵列和 SRAM 行为模型。
- `syn/`：该版本综合脚本、综合报告和门级产物。
- `testbench/`：pre-syn/post-syn 仿真 testbench 和公共 memory 模型。
- `remote_logs/`：远端仿真和综合时抓回的日志。
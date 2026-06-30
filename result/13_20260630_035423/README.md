# 快照 13：20260630_035423

本目录是 Lab8 第 13 版实验结果快照。该版本消除每个 A word 计算前的 `S_COMPUTE_ADDR` 地址气泡，在 `S_LOAD_A_WRITE` 末尾提前发出第一个 B SRAM read，从而减少周期数。

## 版本要点

- direct-A `1x32` 结构保持不变
- 新增 compute-address bubble elimination
- 综合使用 `compile_ultra -gate_clock -area_high_effort_script`
- pre-syn VCS 周期数：`5,586,946`
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

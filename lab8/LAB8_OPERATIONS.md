LAB8 具体操作指南

目的：该文档给出在本仓库 `lab8` 下运行、测试与开发加速器所需的逐步操作命令，适合学生按步骤完成作业并生成可提交材料。

前提：已在系统上安装以下工具：
- Icarus Verilog (`iverilog`, `vvp`) 或者 Verilator（用于 fast-flow）。
- Python 3（用于 `InputGen.py`、`CheckResult.py`）。
- GNU Make（可选）。
- GTKWave（用于查看 `wave.vcd`，可选）。

目录说明（只列出需要运行/编辑的文件）：
- `lab8_framework/lab8_framework/`：最小参考实现（适合初学者、直接用 Icarus 运行）。主要文件：
  - `accelerator.v`：加速器 RTL 示例。你需要在此实现或替换为任务要求的矩阵乘法实现。
  - `mem.v`：仿真用 RAM 模块。
  - `testbench_top.v`：顶层 testbench（会载入 `input_mem.csv`，启动加速器，并写出 `result_mem.csv` 与 `wave.vcd`）。
  - `input_mem.csv`：输入内存初始内容（十六进制，每行对应一个 word）。
  - `result_mem.csv`：仿真后生成的输出内存快照（对比/提交用）。
  - `makefile`：若系统安装 make 与 iverilog，可直接运行 `make`。

- `lab8_flow_fast/lab8_flow_fast/`：Verilator 快速仿真流（面向性能评估、自动化验证）。主要文件：
  - `accelerator.v`, `mem.v`, `testbench_top.v`：与 framework 对应的 RTL/内存/testbench（可能有细微差别以支持 Verilator）。
  - `sim_main.cpp`：Verilator 的 C++ 驱动，可用来构建更快的仿真可执行文件。
  - `InputGen.py`：生成 `input_mem.csv` 或 `in.npy` 的脚本。
  - `CheckResult.py`：校验 `result_mem.csv` 的脚本（请按 `task.md` 中提示调整第 40/41 行）。
  - `SRAM_Specs.xlsx`：SRAM 相关规格参考（可选）。
  - `makefile`：包含常用的构建/仿真规则（例如 `make generate_input`, `make`, `make check_result`, `make clean`）。
  - `obj_dir/`：Verilator 构建产物目录（存在则说明曾用 Verilator 构建过）。

- `lab8_flow_240721/`：历史示例（参考用），结构类似 `lab8_flow_fast`。

操作步骤（顺序执行）

1) 选择仿真流
- 初学者：推荐使用 `lab8_framework`（Icarus）。
- 需要更快或想跑大规模测试：使用 `lab8_flow_fast`（Verilator）。

2) 生成输入数据
- 若使用 `lab8_flow_fast`：进入 `lab8_flow_fast/lab8_flow_fast`，运行：

```powershell
make generate_input
```

- 或者手动运行：

```powershell
python InputGen.py
```

- 该步骤会生成 `input_mem.csv`（或 `in.npy`），数据排布遵循 `task.md` 的约定：第一个 512×512 矩阵在低地址，第二个矩阵从地址 `23'd32768` 开始（默认行为请参考 `InputGen.py`）。

3) 运行仿真
- Icarus（`lab8_framework`）:

```powershell
cd lab8\lab8_framework\lab8_framework
make
# 或：
iverilog -o sim.out testbench_top.v accelerator.v mem.v
vvp sim.out
```

- Verilator（`lab8_flow_fast`）示例流程：

```powershell
cd lab8\lab8_flow_fast\lab8_flow_fast
make    # makefile 应包含 verilate / build & run 流程
# 或手动：
verilator --cc --exe testbench_top.v sim_main.cpp accelerator.v mem.v --build
.
# 运行生成的可执行文件（Windows 下路径可能在 obj_dir\）
obj_dir\Vtestbench_top.exe
```

4) 仿真输出与波形
- 仿真会生成 `result_mem.csv`（结果）与 `wave.vcd`（波形）。
- 使用 `GTKWave` 打开 `wave.vcd`：

```powershell
gtkwave wave.vcd
```

5) 检查结果
- 根据 `task.md`，需要调整 `CheckResult.py`（注释/反注释第 40/41 行），然后运行：

```powershell
cd lab8\lab8_flow_fast\lab8_flow_fast
make check_result
# 或
python CheckResult.py
```

6) 调试与开发建议
- 如果仿真没有读写数据，先检查 `mem.v` 的 `web`（低有效）与 `accelerator` 的 `mem_read_enb`/`mem_write_enb` 极性是否一致。
- 若出现时序问题或行为依赖时钟，请在 `testbench_top.v` 里调整 `T`（时钟周期宏）以调试不同频率行为。
- 若要做规模化验证或性能测试，可在 `InputGen.py` 中更改样本规模并用 Verilator 的 C++ 驱动做批量测试。

7) 综合与 PPA（后期）
- 编写 `syn.tcl`：把 `accelerator` 作为待综合模块，top-level 拉掉 SRAM 的实例（SRAM 端口拉到顶层）。
- 使用你的综合工具（学校/公司环境）运行 `syn.tcl`，收集面积、延迟、功耗报告。

8) 打包提交
- 按 `task.md` 要求准备以下文件并打包：
  - 设计报告（含 PPA 计算与得分）
  - RTL 源码（`accelerator.v` 等）
  - 测试脚本与仿真文件（`testbench_top.v`, `InputGen.py`, `CheckResult.py`, `input_mem.csv` 等）
  - `syn.tcl` 与综合报告（PPA 原始报告）

故障排查要点
- `result_mem.csv` 全零或未写入：检查 `mem_write_enb` 的赋值极性以及 `mem.v` 中 `web` 低有效写使能的结合。
- `CheckResult.py` 报错：按 `task.md` 指示修改第 40/41 行（注释/反注释）以启用正确的检查路径。
- Verilator 构建失败：确认 `sim_main.cpp` 的头文件引用路径及 `verilator` 版本兼容性。

我已把该文档保存为 `LAB8_OPERATIONS.md` 于 `lab8` 目录下。

下一步：我可以立即为你运行 `make generate_input` 或 `make`（你选目录与仿真流）。
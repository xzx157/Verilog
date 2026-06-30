# lab8 说明文档（概览）

本文档概述工作区中 `lab8` 目录下各子目录与主要文件的作用，方便快速定位与仿真使用。

**目录结构（主要子目录）**
- lab8_framework: 基本的 RTL + 仿真参考实现（Icarus/`vvp`/`iverilog` 可直接运行）。
- lab8_flow_fast: 面向更快仿真的流程，包含 Verilator 相关文件和生成的 `obj_dir/`（可构建本地可执行仿真）。
- lab8_flow_240721: 历史/备份版本，结构与 `lab8_flow_fast` 类似，可作参考。

**lab8_framework 目录**
- 文件: [lab8/lab8_framework/lab8_framework/accelerator.v](lab8/lab8_framework/lab8_framework/accelerator.v)
  - 描述: 加速器 RTL 模块。实现一个简单的有限状态机，从输入 RAM 读两个 64 位数，做运算（示例为相加），并把结果写回结果 RAM；输出 `busyb`/`done` 指示状态。
- 文件: [lab8/lab8_framework/lab8_framework/mem.v](lab8/lab8_framework/lab8_framework/mem.v)
  - 描述: 参数化同步 RAM 模块（`DATA_WIDTH`、`ADDR_WIDTH` 可配置），提供读/写接口给 `accelerator` 与 testbench 使用。
- 文件: [lab8/lab8_framework/lab8_framework/testbench_top.v](lab8/lab8_framework/lab8_framework/testbench_top.v)
  - 描述: 顶层 testbench。读取 `input_mem.csv` 到输入 RAM，给 `accelerator` 发出启动脉冲（`comp_enb`），仿真结束后把结果 RAM 内容写出到 `result_mem.csv`，同时生成波形文件 `wave.vcd`。
- 文件: [lab8/lab8_framework/lab8_framework/input_mem.csv](lab8/lab8_framework/lab8_framework/input_mem.csv)
  - 描述: 初始输入内存数据（十六进制文本，供 `$readmemh` 使用）。
- 文件: [lab8/lab8_framework/lab8_framework/result_mem.csv](lab8/lab8_framework/lab8_framework/result_mem.csv)
  - 描述: 仿真后写出的结果内存快照（可用于检查 / 回归测试）。
- 文件: [lab8/lab8_framework/lab8_framework/makefile](lab8/lab8_framework/lab8_framework/makefile)
  - 描述: 用于驱动仿真（通常包含 `iverilog`/`vvp` 的规则），便于一键运行。
- 目录/文件: `wave` / `wave.vcd`
  - 描述: 仿真产生的波形目录与 VCD 文件，可用 GTKWave 打开查看信号波形。

**lab8_flow_fast 目录**
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/accelerator.v](lab8/lab8_flow_fast/lab8_flow_fast/accelerator.v)
  - 描述: 与 `lab8_framework` 中的 RTL 类似，可能包含与 fast-flow（Verilator）集成时的小改动或端口对齐。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/mem.v](lab8/lab8_flow_fast/lab8_flow_fast/mem.v)
  - 描述: 与 framework 中相同或兼容的内存模型，用于仿真数据源/接收。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/testbench_top.v](lab8/lab8_flow_fast/lab8_flow_fast/testbench_top.v)
  - 描述: 顶层 testbench，通常被 Verilator 的 C++ 驱动或直接用 Icarus 使用。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/sim_main.cpp](lab8/lab8_flow_fast/lab8_flow_fast/sim_main.cpp)
  - 描述: Verilator 的 C++ 主程序（示例），用于构建更快的仿真可执行文件并与 Python /文件 I/O 集成。
- 目录: [lab8/lab8_flow_fast/lab8_flow_fast/obj_dir](lab8/lab8_flow_fast/lab8_flow_fast/obj_dir/)
  - 描述: Verilator 生成的中间/目标文件（编译后的 C++ 源、可执行文件等）。通常不手动编辑，属于构建产物。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/InputGen.py](lab8/lab8_flow_fast/lab8_flow_fast/InputGen.py)
  - 描述: 辅助脚本，用于生成输入数据（`input_mem.csv` / `in.npy` 等）。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/CheckResult.py](lab8/lab8_flow_fast/lab8_flow_fast/CheckResult.py)
  - 描述: 检查仿真输出（`result_mem.csv` 或 Verilator 输出）是否正确的脚本，便于自动检验结果。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/in.npy]
  - 描述: 二进制 numpy 输入样本（可被 `InputGen.py` 或 C++ 读取）。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/SRAM_Specs.xlsx](lab8/lab8_flow_fast/lab8_flow_fast/SRAM_Specs.xlsx)
  - 描述: SRAM/存储器接口说明或规格文档，供仿真/后端参考。
- 文件: [lab8/lab8_flow_fast/lab8_flow_fast/readme.md](lab8/lab8_flow_fast/lab8_flow_fast/readme.md)
  - 描述: 该目录特有的使用说明（如何用 Verilator 构建、输入/输出格式等）。

**lab8_flow_240721（历史/例子）**
- 结构: 含 `accelerator.v`、`mem.v`、`testbench_top.v`、`InputGen.py`、`CheckResult.py`、`input_mem.csv`、`result_mem.csv`、`wave.vcd` 等。
- 描述: 这是一个早期/备份版本，保留原始示例和脚本，可用于对比或回溯变更历史。

**常见文件说明（总结）**
- `accelerator.v`: RTL 逻辑，关键内容为有限状态机与内存读写交互。
- `mem.v`: 仿真用的简单同步 RAM（参数化）。
- `testbench_top.v`: 顶层仿真脚本，负责加载输入、启动加速器、导出结果与波形。
- `input_mem.csv`: 初始内存数据（供 `$readmemh`）。
- `result_mem.csv`: 仿真结束后写出的结果内存快照。
- `makefile`: 快速运行仿真的规则（Icarus/Verilator），一般包含 `make sim` / `make verilate` 之类目标。
- `sim_main.cpp` / `obj_dir/`: Verilator 快速流相关的 C++ 驱动与生成目录。
- `InputGen.py` / `CheckResult.py`: Python 脚本，分别用于生成输入与校验输出。

**快速上手（用 Icarus/iverilog）**
1. 进入 `lab8/lab8_framework/lab8_framework`。
2. 运行（如果 `makefile` 已定义）：

```
make
# 或者手动：
iverilog -o sim.out testbench_top.v accelerator.v mem.v
vvp sim.out
```
3. 生成 `wave.vcd`，用 GTKWave 打开查看；`result_mem.csv` 包含输出结果。

**快速上手（用 Verilator 快速流）**
1. 进入 `lab8/lab8_flow_fast/lab8_flow_fast`。
2. 常见流程（示例）：

```
# 运行 Verilator（需要已安装 Verilator）
verilator --cc --exe testbench_top.v sim_main.cpp accelerator.v mem.v --build
# 之后运行生成的可执行文件（通常在 obj_dir 下）
./obj_dir/Vtestbench_top
```
3. 使用 `CheckResult.py` 检查输出，或用 `readme.md` 中的具体步骤。

**注意事项**
- 仿真脚本中 `mem` 模块的 `web` / `cs` 极性需与 `accelerator` 的 `mem_read_enb`/`mem_write_enb` 逻辑对应；若发现读/写失效，请检查极性（`mem.v` 中 `web` 为低有效写使能）。
- `lab8_flow_fast/obj_dir` 为构建产物，不应纳入版本控制（通常被 `.gitignore` 忽略）。

---

如果你需要，我可以：
- 在本机运行 `lab8_framework` 的仿真并把生成的 `result_mem.csv` / `wave.vcd` 展示给你；或
- 针对 `accelerator.v` 做逐行注释解释并指出潜在问题（例如信号极性、阻塞赋值 vs 非阻塞赋值的使用等）。

# Lab8 详细操作指南

本文面向当前工作区的 Lab8 内容，整合了三部分信息：

- 现有实验框架（framework 与 fast flow）
- 新增的 Use-SRAM-Example 示例工程
- 思路介绍 PDF 中的架构建议与评分口径

目标是让你可以从环境检查开始，一路做到功能验证、设计优化、综合评估与最终提交。

---

## 1. 你现在有哪些可用工程

建议先认清每个目录的职责，避免在错误目录改代码。

- [lab8_framework/lab8_framework](lab8_framework/lab8_framework)
  - 最小可运行框架（Icarus Verilog 直接跑）
  - 适合先打通流程
- [lab8_flow_fast/lab8_flow_fast](lab8_flow_fast/lab8_flow_fast)
  - 带 Python 输入生成与结果检查
  - 适合做批量测试与自动化验证
- [Use-SRAM-Example](Use-SRAM-Example)
  - 演示三种存储接入方式：
  - (a) 2D 数组推断 RAM
  - (b) SRAM 宏在加速器内部实例化
  - (c) SRAM 端口上提到顶层（推荐你重点看）

---

## 2. 环境准备（Windows PowerShell）

### 2.1 必备工具

- Icarus Verilog（iverilog, vvp）
- Python 3（建议 3.12/3.13，兼容性更稳）
- Python 包 numpy（用于 InputGen.py / CheckResult.py）

可选工具：

- Verilator（更快仿真）
- GTKWave（看波形）
- make（可选，当前 PowerShell 环境可能没有）

### 2.2 快速检查命令

在 PowerShell 执行：

~~~powershell
iverilog -V
vvp -V
python --version
~~~

安装 numpy：

~~~powershell
python -m pip install numpy
~~~

---

## 3. 一条最稳的起步路径（先跑通再优化）

建议按 A -> B -> C 的顺序推进。

- A：先在 framework 跑通一个最小例子
- B：切到 fast flow 做输入生成和结果检查
- C：吸收 Use-SRAM-Example 的 SRAM 端口上提思路，重构你的正式设计

---

## 4. A 路线：framework 最小闭环

目录：[lab8_framework/lab8_framework](lab8_framework/lab8_framework)

### 4.1 编译并运行

~~~powershell
Set-Location .\lab8_framework\lab8_framework
iverilog -g2012 -Wall -o wave testbench_top.v
vvp -n wave
~~~

### 4.2 你会看到什么输出

- 结果文件：result_mem.csv
- 波形文件：wave.vcd

### 4.3 波形查看（可选）

~~~powershell
gtkwave wave.vcd
~~~

重点观察信号：

- comp_enb
- busyb
- done
- mem_addr / mem_data
- res_addr / res_data

---

## 5. B 路线：fast flow 的输入与校验

目录：[lab8_flow_fast/lab8_flow_fast](lab8_flow_fast/lab8_flow_fast)

### 5.1 生成输入

~~~powershell
Set-Location .\lab8_flow_fast\lab8_flow_fast
python InputGen.py
~~~

会生成：

- input_mem.csv
- in.npy

### 5.2 运行 Verilog 仿真（Icarus）

~~~powershell
iverilog -g2012 -Wall -o wave testbench_top.v
vvp -n wave
~~~

会输出：

- result_mem.csv

### 5.3 结果检查

根据课程要求，需要在 [lab8_flow_fast/lab8_flow_fast/CheckResult.py](lab8_flow_fast/lab8_flow_fast/CheckResult.py) 中切换第 40/41 行使用的结果来源（注释一行、取消另一行），然后执行：

~~~powershell
python CheckResult.py
~~~

### 5.4 Verilator（可选）

若已安装 Verilator，可按 [lab8_flow_fast/lab8_flow_fast/readme.md](lab8_flow_fast/lab8_flow_fast/readme.md) 执行：

~~~powershell
verilator -cc -trace --timing testbench_top.v -exe sim_main.cpp
Copy-Item .\input_mem.csv .\obj_dir\input_mem.csv -Force
Set-Location .\obj_dir
make -f Vtestbench_top.mk
.\Vtestbench_top.exe
~~~

---

## 6. C 路线：Use-SRAM-Example 的正确打开方式

目录：[Use-SRAM-Example](Use-SRAM-Example)

### 6.1 这个目录在教什么

它不是 512x512 完整实现，而是一个结构教学样例，核心是比较三种存储集成方式：

- accelerator_array.v：数组推断存储
- accelerator_sram.v：SRAM 宏封在加速器内部
- accelerator_sram_ext.v + accelerator_top.v：SRAM 端口外提、在顶层连接

其中第 3 种方式最接近课程里“综合时剔除 SRAM macro、把 SRAM port 拉到顶层”的要求。

### 6.2 直接编译运行（无 make 版本）

~~~powershell
Set-Location .\Use-SRAM-Example
iverilog -g2012 -Wall -o sim.vvp sram_model.v accelerator_array.v accelerator_sram.v accelerator_sram_ext.v accelerator_top.v tb_accelerator.v
vvp sim.vvp
~~~

若输出包含 ALL TESTS PASSED 且 0 errors，说明三种实现在 testbench 中对齐。

### 6.3 使用 Makefile（有 make 时）

目录中已有 [Use-SRAM-Example/Makefile](Use-SRAM-Example/Makefile)，可执行：

~~~powershell
make
~~~

但在纯 PowerShell 场景下可能没有 make，这时用 6.2 的命令即可。

### 6.4 你要迁移到自己正式设计的关键点

建议按这个原则改正式工程：

- accelerator 核心只保留计算与调度逻辑
- SRAM 接口信号显式外露（cs_n, we_n, addr, wdata, rdata）
- 顶层完成 SRAM 宏实例化与端口绑定

这样做的收益：

- 便于综合时剔除 SRAM macro
- 便于后续做 SRAM 规格替换和面积功耗估算
- 结构层次更清晰，测试更容易拆分

---

## 7. 结合思路 PDF 的设计路线（适配 512x512 INT8）

PDF 里给了三类常见结构：

- 脉动阵列（systolic）
- 广播阵列（broadcast）
- 加法树（adder tree）

对于本项目，建议采取“分块 + 混合阵列”的工程化策略，而不是直接上超大单块阵列。

### 7.1 为什么不能直接做 512x512 超大阵列

- 面积与功耗不可控
- 布局布线压力过高
- 数据搬运很可能成为瓶颈（memory-bound）

### 7.2 推荐分块思路

以 8x8 PE 子阵列为基本计算单元，按时间步和空间块分解 512x512：

- 列方向分块（每次处理 8 列）
- 行方向分块（每次处理 8 行）
- 与输入/输出搬运尽量 overlap

PDF 示例给出过一个参考总周期估计：100880 cycles（仅作思路参考，不是唯一答案）。

### 7.3 模块划分建议（强烈建议层次化）

- top_controller：流程调度与状态控制
- input_loader：读取并缓存 A/B 子块
- pe_array_8x8：核心 MAC/累加
- partial_sum_buffer：中间结果缓存
- writeback_engine：写回 result memory
- accelerator_top：顶层连接 SRAM 端口与控制

---

## 8. 数据排布与接口口径（避免后期返工）

### 8.1 输入排布

按课程说明与脚本约定：

- 输入是 1024 x 512 的 INT8 数据
- 前 512 行对应矩阵 A
- 后 512 行对应矩阵 B

CheckResult.py 默认按这个口径重建黄金结果。

### 8.2 结果精度

输入 INT8，累加深度 512。中间累加建议至少使用更宽整数（例如 INT32 或更宽），避免溢出导致 NMSE 异常上升。

---

## 9. 验证与评分口径（必须对齐）

### 9.1 功能正确性

- 先确保结果数值对齐黄金模型
- 再谈频率/面积/功耗优化

### 9.2 延迟统计口径

课程文档给出的口径是：

- 从 comp_enb 下降沿开始计时
- 到 busyb 上升沿结束

### 9.3 评分公式（按当前课程说明）

$$
Score = \exp(NMSE / C0) \times Power\,(mW) \times Area\,(\mu m^2)^2 \times Time\,(\mu s)
$$

其中 $C0 = 1 \times 10^{-3}$。

### 9.4 综合边界

根据课程要求：

- 逻辑综合时应剔除 SRAM macro（端口拉顶层）
- Top Controller、Input Memory、Result Memory 不计入最终 PPA
- 仅看 accelerator 的 PPA

---

## 10. 从今天到提交的执行计划（实用版）

### 阶段 1：打通与校验

1. 跑通 framework 与 fast flow
2. 跑通 Use-SRAM-Example 三版本对比
3. 固化你自己的数据格式与检查脚本

### 阶段 2：架构落地

1. 完成 8x8（或你选定规模）PE 子阵列
2. 完成分块调度与地址生成
3. 完成部分和缓存与写回链路

### 阶段 3：优化与收敛

1. 做 overlap（读/算/写并行）
2. 调整时钟目标与流水级
3. 输出最终功能、延迟、PPA 报告

### 阶段 4：提交

按课程要求打包：

- 设计报告（含得分计算）
- 设计与测试代码
- syn.tcl
- PPA 原始报告

---

## 11. 常见问题与解决

### 11.1 报错 No module named numpy

执行：

~~~powershell
python -m pip install numpy
~~~

如果你使用的是 Python 3.14，且安装 numpy 时出现构建依赖错误（例如需要 ninja/make/cmake），建议优先切换到 Python 3.12/3.13 虚拟环境后再安装 numpy。

### 11.2 Icarus 出现 VCD warning: Unsupported argument type (vpiPackage)

将 testbench 中：

- $dumpvars(0);

改为：

- $dumpvars(0, testbench_top);

通常可避免该警告。

### 11.3 result_mem.csv 全零或未更新

重点检查：

- mem.v 中 web 的低有效逻辑
- 加速器中的读写使能极性是否与 mem.v 对齐
- 写地址与写数据是否在有效周期稳定

### 11.4 make 不可用

可直接使用本文给出的 iverilog + vvp 命令，不影响主流程。

---

## 12. 你现在最应该先做什么

建议立即执行下面三条，确认环境与流程都正常：

~~~powershell
Set-Location .\Use-SRAM-Example
iverilog -g2012 -Wall -o sim.vvp sram_model.v accelerator_array.v accelerator_sram.v accelerator_sram_ext.v accelerator_top.v tb_accelerator.v
vvp sim.vvp
~~~

这一步通过后，再进入你自己的 accelerator 正式实现与优化。

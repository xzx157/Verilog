# Lab8 优化迭代流程

本文档作为后续优化迭代的固定参考。每一次迭代都必须保持与现有 `result/summary/version_metrics_summary.md` 相同的汇总风格，并在 `result/` 下留下完整快照。

## 目标

当前基线为 `1_20260624_235307`：

| 指标 | 数值 |
|---|---:|
| SSE | 0 |
| Area | 36,376.658457 um^2 |
| Latency | 8,996,211.911 ns |
| Total power | 112.025771 mW |
| Score | 1.33359274454627E+15 |

后续迭代优先针对以下已知弱点：

| 问题 | 当前状态 | 优化方向 |
|---|---|---|
| SRAM IO 浪费 | 使用 `512x16` SRAM，但只使用低 8 bit | 将两个 SINT8 打包到一个 16-bit SRAM word；或者只有在能充分使用位宽时才选择更宽 SRAM macro |
| 累加器位宽 | 当前使用 32-bit 部分和 | 先检查 24-bit signed 累加是否数学上足够，再综合更窄计算核，同时最终仍输出 int32 兼容结果 |
| SRAM 型号选择 | 当前使用合法但不一定最优的 `512x16` macro | 从 `sram.md` 建候选表，综合考虑 SRAM 总面积、功耗和 latency 影响后选择 |

阶段性优化目标：

| 指标 | 目标 |
|---|---:|
| NMSE/SSE | `0` |
| Total power | `< 2e10 pW` |
| Latency | `< 2.5e6 ns` |

优先完成用户指定的三类优化：充分使用 SRAM 位宽、缩小 accumulator 位宽、重新选择 SRAM 型号。完成这些优化后，可以提出新的优化方式，但必须先说明假设、预期收益和风险，并获得用户批准后再实施。

## 固定评分规则

统一使用 task 的评分口径：

```text
score = exp(SSE / C0) * power(mW) * area(um^2)^2 * latency(us)
C0    = 1e-3
```

Latency 使用 task 允许的方法之一。后续迭代统一采用：

```text
latency = cycle_count * shortest_clock_period
shortest_clock_period = target_clock_period - setup_slack
```

当前报告中：

```text
target_clock_period = 2000.00 ps
setup_slack         = 从 syn/log/timing.rpt 读取
shortest_period     = target_clock_period - setup_slack
```

功耗必须与 latency 使用同一频率基准：

端到端跑的轮数由 full pre-syn 512x512 仿真或完整 `accelerator_top` 控制 FSM 决定；综合不改变 `cycle_count`，但 timing slack 决定 `shortest_clock_period`，因此会压缩 latency。Power 不按 shortest period 重新缩放，而是使用测得/报告功耗对应的 target clock 频率。

```text
cycle_count     = full 512x512 controller 行为决定
shortest_period = synthesis timing report 决定
latency         = cycle_count * shortest_period
power_frequency = 1_000_000 / target_period_ps
dynamic_power   = dynamic_power_at_target_clock
```

`syn/log/power.rpt` 中的 logic dynamic power 是综合 target clock 下的报告值，直接使用该报告值：

```text
logic_dynamic_mW = reported_logic_dynamic_mW
logic_total_mW   = logic_dynamic_mW + logic_leakage_mW
```

SRAM 功耗由 `sram.md` 解析计算：

```text
sram_leakage_total_mW = instance_count * leakage_uW / 1000
sram_dynamic_total_mW = instance_count * dynamic_uW_per_MHz * power_frequency_MHz / 1000
sram_total_mW         = sram_leakage_total_mW + sram_dynamic_total_mW
total_power_mW        = logic_total_mW + sram_total_mW
```

DC 逻辑 PPA 不包含 SRAM macro、top controller、input memory、result memory、data memory。最终报告需要 SRAM macro 功耗/面积时，只能从 SRAM 表格中解析后手算加入。

## 快照规则

每次迭代建立一个新的不可变快照目录：

```text
result/<sequence>_<YYYYMMDD_HHMMSS>/
```

快照必须能用于快速回退。若某次优化失败或指标变差，应能直接从上一个成功的 `result/<sequence>_<timestamp>/` 恢复 `rtl/`、`testbench/`、`syn/`、脚本、输入输出文件和报告，不依赖当前 `main/` 的临时状态。

每个快照必须包含：

| 提交要求 | 必需路径 |
|---|---|
| 设计代码 | `rtl/` |
| 测试代码 | `testbench/` |
| 综合脚本 | `syn/syn.tcl` |
| PPA 原始报告 | `syn/log/area.rpt`, `power.rpt`, `timing.rpt`, `constraints.rpt` |
| 功能检查脚本 | `CheckResult.py` |
| 输入与输出结果 | `input_mem.csv`, `result_mem.csv`, `in.npy` |
| 设计报告 | `result.md` |

同时在 `result/` 顶层生成一份详细报告副本：

```text
result/snapshot_summaries/v<sequence>_<YYYYMMDD_HHMMSS>_summary.md
```

每次迭代结束后更新 `result/summary/version_metrics_summary.md`，保持以下小节：

```text
Accuracy
Latency
Power
Score
Final Metrics
```

`result/summary/version_metrics_summary.md` 中所有时间列统一使用 ns，所有功耗列统一使用 pW。

## 单轮迭代模板

每个候选设计按以下顺序执行。

### 1. 写清设计假设

编辑 RTL 前，先在该轮报告草稿中记录简短假设：

```text
Hypothesis:
- 架构上改了什么
- 为什么应该降低 score
- 对 area、latency、power、正确性风险的预期影响
```

假设必须可证伪。例如：

```text
将两个 SINT8 打包到每个 16-bit SRAM word 中，应该能把 A/B bank 的内部 SRAM 深度从 512 降到 256，并降低单 bank SRAM leakage/dynamic。正确性风险主要来自偶/奇 byte 选择和 signed extension。
```

每次个人 `result.md` 必须写清楚本轮到底改了什么，至少包含：

```text
Design Change:
- 修改的模块/文件
- 架构变化
- SRAM macro 编号、word 数、IO bit、实例数
- accumulator 位宽
- controller/FSM cycle_count 是否变化
- 与上一轮相比的预期收益和新增风险
```

### 2. 每轮只改一类问题

第一轮不要把所有优化混在一起改。分开迭代，才能在结果表中看出每个优化真正带来的收益。

推荐顺序：

1. SRAM packing 与 SRAM macro 重选。
2. 24-bit accumulator core。
3. 组合最佳 SRAM 与 24-bit 设计。
4. 如果前三项都通过，再考虑 tile-size 或调度微调。

### 3. 功能验证

沿用基线流程：

1. 同步到远端。
2. 远端运行 pre-syn simulation，生成 `result_mem.csv`。
3. 抓回本地 `result_mem.csv`。
4. 在本地 `.venv` 中运行 checker：

```powershell
cd D:\repository\Verilog\main
..\.venv\Scripts\python.exe CheckResult.py
```

通过条件：

```text
Correct!
>>loss is 0
>>sse is 0.0
```

如果 SSE 非零，只有当该轮明确是近似计算设计时才保留为有效快照。当前项目优先保持精确 INT 输出和 `SSE = 0`，除非后续明确决定改变精度。

### 4. Logic-only 综合

综合 top 必须是 `accelerator_logic_top`。综合设计不得实例化 SRAM macro，也不得包含 full top controller。

综合后检查：

| 检查项 | 期望 |
|---|---|
| `syn/log/area.rpt` design | `accelerator_logic_top` |
| Macro/black boxes | `0` |
| Setup slack | positive |
| `syn/log/power.rpt` | dynamic 和 leakage 数值有效 |

不要加入 hold 优化。当前 task 和现有流程只用 setup slack 进行评分计算。

### 5. Post-syn 网表/SDF 快速检查

综合成功后运行现有 post-syn testbench。通过条件：

```text
[POST-SYN] PASS
```

这一步只检查 gate-level netlist 能否编译、SDF 能否正确标注、计算核小样例是否能跑通。它不是完整 512x512 功能证明，也不是端到端 latency 的来源。

### 6. 重新计算指标

从报告中提取：

| 来源 | 数值 |
|---|---|
| `syn/log/area.rpt` | total cell area |
| `syn/log/timing.rpt` | target period 与 setup slack |
| `syn/log/power.rpt` | reported dynamic 与 leakage |
| full `accelerator_top` 的 RTL/FSM 或 pre-syn testbench 显式打印 marker | 端到端 cycle count |
| `sram.md` | 选中 macro 的 leakage/dynamic/area |

然后计算：

```text
shortest_period_ps = target_period_ps - setup_slack_ps
latency_ns         = cycle_count * shortest_period_ps / 1000
frequency_MHz      = 1_000_000 / shortest_period_ps
total_power_mW     = scaled_logic_power_mW + analytical_sram_power_mW
score              = exp(SSE / 1e-3) * total_power_mW * area_um2^2 * latency_us
```

端到端 latency 的定义来自 task：从 `comp_enb` 下降沿到 `busyb` 上升沿。它必须来自完整功能 top，也就是包含 controller 调度的 `accelerator_top`，不能来自 `accelerator_logic_top` 的 post-syn 小样例。

当前基线的端到端 cycle count 是根据 `accelerator_top` FSM 推导得到：

```text
cycle_count = 1 + 42 * 32 * 16066 + 32 * 16003
            = 22,104,801 cycles
```

后续迭代必须在 pre-syn full testbench 中显式打印 marker，避免只靠手算：

```text
[TB][LATENCY] start_ns=<comp_enb_fall_time> end_ns=<busyb_rise_time> cycles=<cycle_count>
```

详细 `result.md` 中保留未四舍五入的精确值。汇总文件 `result/summary/version_metrics_summary.md` 中，latency ns 和 pW 列按整数显示，保持表格一致性。

## 优化计划

### Plan A：充分使用 SRAM IO 位宽

当前设计使用 `512x16` SRAM banks，但只使用 `rdata[7:0]`。优先优化这一点，因为它能减少 SRAM 浪费，并且不改变数学精度。

候选实现：

```text
A SRAM bank word = {A[row][2k+1], A[row][2k]}
B SRAM bank word = {B[2k+1][col], B[2k][col]}
```

然后从一个 SRAM word 中计算连续两个 K step：

```text
even pulse: 使用 low byte
odd pulse : 使用上一拍锁存 word 的 high byte
```

预期 SRAM macro 变化：

```text
512x16 -> 256x16，如果每个 bank 存 256 个 packed K-pair
```

根据 `sram.md`，单 bank 候选从 No.35 变为 No.26：

| No. | Word | IO bit | Area (um^2) | Leakage (uW) | Dynamic (uW/MHz) |
|---:|---:|---:|---:|---:|---:|
| 35 | 512 | 16 | 99.698151 | 15.115625 | 0.143354 |
| 26 | 256 | 16 | 68.240402 | 11.52795 | 0.134196 |

必须验证：

- low/high byte 的 signed extraction 是否正确。
- 偶/奇 K 调度是否引入额外周期，导致 SRAM 收益被抵消。
- result writer 是否仍输出 int32 兼容的 `result_mem.csv`。

### Plan B：重新评估 SRAM macro 选择

完成 packing 后，至少比较以下族：

| 候选 | 适用场景 |
|---|---|
| `256x16` | K=512 时自然存两个 INT8 一组 |
| `128x32` | 每 word 存四个 INT8，可能降低 word 数，但需要更宽 unpack/control |
| `64x64` | 每 word 存八个 INT8，可能降低读次数，但可能提高 macro dynamic 和控制/布线复杂度 |
| `32x128` | 高带宽方案；只有当控制逻辑能充分消费大部分 bit 时才值得 |

每个候选都记录：

```text
bank_count
words_per_bank
bits_used_per_read / io_bits
SRAM area total
SRAM leakage total
SRAM dynamic total at score frequency
added control area/power
cycle count impact
```

不要只按单个 SRAM 功耗最低来选。最终选择必须看综合后的总 score，因为更宽 SRAM port 可能增加 mux/control 逻辑面积和功耗。

### Plan C：24-bit accumulator

SINT8、长度 512 的 dot product 最坏情况边界：

```text
max_abs_product = 128 * 128 = 16,384
max_abs_sum     = 512 * 16,384 = 8,388,608
```

signed 24-bit 范围：

```text
-8,388,608 to 8,388,607
```

这刚好卡在边界上。因为 `(-128) * (-128) * 512 = 8,388,608`，纯 signed 24-bit 无法表示正方向最坏端点。不过当前随机输入不一定会触发这个极端情况。若要对所有 SINT8 输入保持严格正确，使用 25-bit 更稳。

| 选项 | Accumulator bits | 风险 |
|---|---:|---|
| 24-bit signed | 最小，但正方向 full-scale 可能溢出 |
| 25-bit signed | 对所有 SINT8 512-term sum 严格足够 |
| 24-bit internal 加输入范围证明 | 只有当输入生成范围排除最坏情况时才成立 |

实现 24-bit 前，先检查 `InputGen.py` 和实际 `input_mem.csv` 的数值范围。如果生成器不会产生 `-128` 或不会触发 full-scale product，需要在报告中写明证明。如果设计要满足 task 中“所有输入为 SINT8”的一般要求，则不要静默缩到 24-bit，优先使用 25-bit。

### Plan D：组合最佳设计

只有在 Plan A/B 与 Plan C 都分别生成独立报告后，才组合最佳 SRAM packing/macro 与选定 accumulator 位宽。

组合迭代必须包含对比表：

| Design | SSE | Area | Latency | Power | Score | Main change |
|---|---:|---:|---:|---:|---:|---|

## 报告风格

每个详细迭代报告应包含：

```text
# Lab8 Result - <design name>

## Summary
## Design Change
## Accuracy
## Latency
## Power
## Area
## Score
## Validation Logs
## Notes
```

`result/summary/version_metrics_summary.md` 保持简洁表格式。每次迭代向每张表追加一行。

## 停止条件

出现以下任一情况时，停止该轮迭代，不把它归档为成功结果：

- 功能 checker 失败，而该设计原本目标是精确计算。
- 综合 top 不是 `accelerator_logic_top`。
- `area.rpt` 显示 SRAM macro 或 black box 被计入 logic PPA。
- Setup slack 为负。
- Power 与 latency 使用了不同频率基准。
- 报告无法明确选中的 SRAM macro 编号和实例数。

若某轮触发停止条件，必须保留失败原因说明，但不要覆盖上一个成功快照。下一步应从最近一个成功快照回退，再重新设计或等待用户确认。

## 下一轮立即开始项

从 Plan A 开始：

```text
Design name: 2_<timestamp>_sram_pack2
Change: pack two SINT8 values per 16-bit SRAM word and target 256x16 SRAM banks
Primary expected win: lower SRAM leakage/dynamic and possibly lower load/read cycles
Primary risk: even/odd byte scheduling and signed extension
Validation: full pre-syn result_mem.csv check, logic-only synthesis, post-syn smoke test
```
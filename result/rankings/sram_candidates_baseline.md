# SRAM Candidate Ranking

排序：Lab8 score 从低到高；`Quality vs base = baseline score / candidate score`，所以 quality 越高越好。
Area mode: `logic-only`
Sort mode: `target-score`

模型：枚举 SRAM 型号与 `A_ROWS x B_COLS` 计算阵列；SRAM word 的 byte lanes 用来并行提供多行 A 或多列 B，SRAM depth 用作 K chunk，尽量装满 macro 容量。此表用于挑 RTL 实验点，最终结果仍以远端 pre-syn/full check 和 DC PPA 为准。

## Scoring Standard

候选空间：对 `sram.md` 中每个 SRAM macro，枚举 `A_ROWS x B_COLS` 计算阵列。
默认 `A_ROWS, B_COLS in [4, 8, 12, 16, 24, 32, 48, 64]`，`PEs = A_ROWS * B_COLS <= 4096`，`ACC_BITS in [24, 25, 32]`，`SRAM count <= 64`。

SRAM packing：

- `int8_per_word = IO_bits / 8`，只考虑 IO 位宽能整除 8 的 macro。
- `K_chunk = min(SRAM_words, 512)`，`K_chunks = ceil(512 / K_chunk)`。
- `A_SRAM = ceil(A_ROWS / int8_per_word)`，`B_SRAM = ceil(B_COLS / int8_per_word)`。
- `capacity_utilization = (A_ROWS*K_chunk + B_COLS*K_chunk) / ((A_SRAM+B_SRAM)*SRAM_words*int8_per_word)`。
- `lane_utilization = (A_ROWS+B_COLS) / ((A_SRAM+B_SRAM)*int8_per_word)`。
- 默认过滤 `capacity_utilization >= 95%`，因此优先选择能把 SRAM macro 装满的组合。

Cycle and latency estimate：

- `cycles_per_sram_word = 2 * ceil(IO_bits / 64)`。
- `A_load_cycles_per_chunk = A_SRAM * K_chunk * cycles_per_sram_word`。
- `B_load_cycles_per_chunk = B_SRAM * K_chunk * cycles_per_sram_word`。
- `compute_cycles_per_chunk = K_chunk * 3 + 0`。
- `write_cycles_per_tile = ceil(A_ROWS*B_COLS / 2) * 2`。
- `tile_cycles = K_chunks*(A_load_cycles_per_chunk + compute_cycles_per_chunk + 8) + write_cycles_per_tile + 16` when B reuse is enabled。
- `total_cycles = 1 + col_tiles * (K_chunks*B_load_cycles_per_chunk + row_tiles*tile_cycles)` when B reuse is enabled。
- B reuse across row tiles: `True`。When disabled, `tile_cycles` includes both A and B load and `total_cycles = 1 + row_tiles*col_tiles*tile_cycles`。
- `shortest_period = target_period - setup_slack = 2000.00 ps - 1593.02 ps = 406.98 ps`。
- `latency_ns = total_cycles * shortest_period_ps / 1000`。

Power and area estimate：

- `power_frequency_MHz = 1e6 / target_period_ps = 500.000 MHz`。
- Baseline logic: area `36376.658457 um^2`, dynamic `11.9860 mW @ 2000 ps`, leakage `42.8377 mW`, baseline PEs `192`。
- Logic scaling uses `baseline * (0.20 + 0.80 * PEs/192)` for area, and the same fixed fraction `0.20` for dynamic/leakage power。
- Accumulator narrowing is modeled by multiplying the scalable PE term by `1 - 0.50 * (1 - ACC_BITS/32)`。这是 24-bit accumulator 的预估项，不替代 DC 综合。
- `logic_dynamic_mW = scaled_dynamic_at_target`，不按 shortest period 重新缩放。
- `sram_power_mW = (A_SRAM+B_SRAM) * (leakage_uW + dynamic_uW_per_MHz*power_frequency_MHz) / 1000`。
- `total_power_mW = logic_dynamic_mW + logic_leakage_mW + sram_power_mW`。
- `score_area = logic_area` when `area-mode=logic-only`; `score_area = logic_area + sram_area` when `area-mode=logic-plus-sram`。

Final score and sorting：

- `Score = exp(SSE/0.001) * total_power_mW * score_area^2 * latency_us`，默认 `SSE=0`。
- Score 越低越好；`Quality vs base = baseline_score / candidate_score`，所以 quality 越高越好。
- `Target = Y` means `power < 2e+10 pW` and `latency < 2.5e+06 ns`。
- `sort-mode=target-score` 的排序键是：先满足 power+latency，再满足 latency，再按 latency miss、power miss、score 排序。

## Target Summary

候选总数：`2946`；满足 power+latency 的候选数：`0`。
没有候选同时达标。满足 latency 的最低功耗候选是 No.3 `32x64`，`8x16`，ACC `24`，power `37109461933 pW`，是目标的 `1.86x`。
满足 power 的最低 latency 候选是 No.36 `512x32`，`4x8`，ACC `24`，latency `8775036 ns`，是目标的 `3.51x`。

| Rank | No. | Word | IO | A_ROWS | B_COLS | ACC | PEs | SRAM A+B | K chunk | Cap util. | Lane util. | Tile cycles | Cycles | Latency ns | Power pW | SRAM area | Logic area | Score | Quality vs base | Target |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | 3 | 32 | 64 | 8 | 16 | 24 | 128 | 1+2 | 32x16 | 100.0% | 100.0% | 2,832 | 5,865,473 | 2,387,130 | 37109461933 | 360.4 | 24251.1 | 5.209834E+13 | 6.446 | N |
| 2 | 11 | 64 | 64 | 8 | 16 | 24 | 128 | 1+2 | 64x8 | 100.0% | 100.0% | 2,768 | 5,734,401 | 2,333,787 | 37131195658 | 395.2 | 24251.1 | 5.096396E+13 | 6.589 | N |
| 3 | 20 | 128 | 64 | 8 | 16 | 24 | 128 | 1+2 | 128x4 | 100.0% | 100.0% | 2,736 | 5,668,865 | 2,307,115 | 37169218933 | 464.8 | 24251.1 | 5.043310E+13 | 6.658 | N |
| 4 | 29 | 256 | 64 | 8 | 16 | 24 | 128 | 1+2 | 256x2 | 100.0% | 100.0% | 2,720 | 5,636,097 | 2,293,779 | 37217460958 | 604.1 | 24251.1 | 5.020666E+13 | 6.688 | N |
| 5 | 38 | 512 | 64 | 8 | 16 | 24 | 128 | 1+2 | 512x1 | 100.0% | 100.0% | 2,712 | 5,619,713 | 2,287,111 | 37281223933 | 882.5 | 24251.1 | 5.014648E+13 | 6.696 | N |
| 6 | 1 | 32 | 32 | 4 | 32 | 24 | 128 | 1+8 | 32x16 | 100.0% | 100.0% | 2,832 | 5,931,009 | 2,413,802 | 37500260533 | 604.7 | 24251.1 | 5.323522E+13 | 6.308 | N |
| 7 | 9 | 64 | 32 | 4 | 32 | 24 | 128 | 1+8 | 64x8 | 100.0% | 100.0% | 2,768 | 5,799,937 | 2,360,458 | 37535517583 | 663.1 | 24251.1 | 5.210769E+13 | 6.444 | N |
| 8 | 3 | 32 | 64 | 8 | 16 | 25 | 128 | 1+2 | 32x16 | 100.0% | 100.0% | 2,832 | 5,865,473 | 2,387,130 | 37566326100 | 360.4 | 24554.2 | 5.406647E+13 | 6.211 | N |
| 9 | 11 | 64 | 64 | 8 | 16 | 25 | 128 | 1+2 | 64x8 | 100.0% | 100.0% | 2,768 | 5,734,401 | 2,333,787 | 37588059825 | 395.2 | 24554.2 | 5.288886E+13 | 6.349 | N |
| 10 | 18 | 128 | 32 | 4 | 32 | 24 | 128 | 1+8 | 128x4 | 100.0% | 100.0% | 2,736 | 5,734,401 | 2,333,787 | 37600019683 | 779.9 | 24251.1 | 5.160744E+13 | 6.507 | N |
| 11 | 20 | 128 | 64 | 8 | 16 | 25 | 128 | 1+2 | 128x4 | 100.0% | 100.0% | 2,736 | 5,668,865 | 2,307,115 | 37626083100 | 464.8 | 24554.2 | 5.233730E+13 | 6.416 | N |
| 12 | 29 | 256 | 64 | 8 | 16 | 25 | 128 | 1+2 | 256x2 | 100.0% | 100.0% | 2,720 | 5,636,097 | 2,293,779 | 37674325125 | 604.1 | 24554.2 | 5.210149E+13 | 6.445 | N |
| 13 | 27 | 256 | 32 | 4 | 32 | 24 | 128 | 1+8 | 256x2 | 100.0% | 100.0% | 2,720 | 5,701,633 | 2,320,451 | 37689302608 | 1013.5 | 24251.1 | 5.143438E+13 | 6.529 | N |
| 14 | 38 | 512 | 64 | 8 | 16 | 25 | 128 | 1+2 | 512x1 | 100.0% | 100.0% | 2,712 | 5,619,713 | 2,287,111 | 37738088100 | 882.5 | 24554.2 | 5.203796E+13 | 6.453 | N |
| 15 | 36 | 512 | 32 | 4 | 32 | 24 | 128 | 1+8 | 512x1 | 100.0% | 100.0% | 2,712 | 5,685,249 | 2,313,783 | 37801851208 | 1480.7 | 24251.1 | 5.143973E+13 | 6.528 | N |
| 16 | 1 | 32 | 32 | 4 | 32 | 25 | 128 | 1+8 | 32x16 | 100.0% | 100.0% | 2,832 | 5,931,009 | 2,413,802 | 37957124700 | 604.7 | 24554.2 | 5.523929E+13 | 6.079 | N |
| 17 | 9 | 64 | 32 | 4 | 32 | 25 | 128 | 1+8 | 64x8 | 100.0% | 100.0% | 2,768 | 5,799,937 | 2,360,458 | 37992381750 | 663.1 | 24554.2 | 5.406871E+13 | 6.211 | N |
| 18 | 18 | 128 | 32 | 4 | 32 | 25 | 128 | 1+8 | 128x4 | 100.0% | 100.0% | 2,736 | 5,734,401 | 2,333,787 | 38056883850 | 779.9 | 24554.2 | 5.354852E+13 | 6.271 | N |
| 19 | 27 | 256 | 32 | 4 | 32 | 25 | 128 | 1+8 | 256x2 | 100.0% | 100.0% | 2,720 | 5,701,633 | 2,320,451 | 38146166775 | 1013.5 | 24554.2 | 5.336744E+13 | 6.292 | N |
| 20 | 36 | 512 | 32 | 4 | 32 | 25 | 128 | 1+8 | 512x1 | 100.0% | 100.0% | 2,712 | 5,685,249 | 2,313,783 | 38258715375 | 1480.7 | 24554.2 | 5.337109E+13 | 6.292 | N |

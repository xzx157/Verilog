# Lab8 Submission

This directory is organized in a lab-style runnable flow: RTL, synthesis scripts, and pre/post-synthesis testbenches are separated under `rtl/`, `syn/`, and `testbench/`. It is intended to be self-contained; files used by the flow are inside this `main/` directory.

## Directory Layout

- `rtl/accelerator_top.v`: functional top for pre-synthesis simulation, including controller and behavioral SRAM models.
- `rtl/accelerator_logic_top.v`: logic-only top used for PPA synthesis. SRAM macros, top controller, input memory, result memory, and data memory are excluded from this synthesis top.
- `rtl/accelerator_sram_ext.v`: PE array / MAC core.
- `rtl/sram_model.v`: behavioral SRAM model for functional simulation only.
- `testbench/pre-syn/`: pre-synthesis functional simulation.
- `testbench/post-syn/`: post-synthesis SDF smoke test for the logic-only top.
- `syn/`: Design Compiler flow.
- `InputGen.py`, `CheckResult.py`: input generation and result checking.

## Commands

From this directory:

```sh
make
```

This checks that required files exist inside `main/` and runs pre-synthesis simulation using the included `input_mem.csv` / `in.npy`. It does not invoke Python or NumPy.

For the full flow:

```sh
make all
```

This runs pre-synthesis simulation, logic-only synthesis, and post-synthesis SDF smoke test using the included input files. It does not invoke Python or NumPy.

Individual targets are also available:

```sh
make check_files
make precheck
make syn
make postcheck
make clean
make distclean
```

The Python targets are optional and intended for local regeneration/checking when NumPy is available:

```sh
make generate_input
make check_result
```

## Tool Requirements

- Either `iverilog`/`vvp` or VCS for pre-synthesis simulation
- Design Compiler command `dc_shell-t` for synthesis
- VCS for post-synthesis SDF smoke test

Python with NumPy is only required for the optional `generate_input` and `check_result` targets.

## PDK Path

`syn/syn.tcl` searches for the NanGate DB only inside this `main/` directory, relative to `syn/`:

1. `../pdk/NanGate_15nm/front_end/timing_power_noise/CCS/NanGate_15nm_OCL_slow_conditional_ccs.db`
2. `../pdk/NanGate_15nm_OCL_slow_conditional_ccs.db`

The post-synthesis testbench searches for the NanGate Verilog model in:

1. `../../pdk/NanGate_15nm/front_end/verilog/NanGate_15nm_OCL_conditional.v`
2. `../../pdk/NanGate_15nm_OCL_conditional.v`

For submission, include the required PDK DB and Verilog model under `pdk/`. The current directory already contains both flat copies under `pdk/`, plus the nested NanGate directory.

## Current Verified Result

The current architecture is direct-A `1x32` with one `10.00ns` clock target, using two No.42 `512x128` B SRAM macros, PE operand isolation, A-zero sparse gating for B SRAM reads, A-zero gating in the logic-only synthesis top, per-A-word compute-address bubble elimination, streamed result writeback, and low-leakage Design Compiler Ultra clock-gated synthesis.

Remote verified metrics:

- Pre-syn marker: `[TB][LATENCY] cycles=5464066 realtime_ns=5464066.500`
- Checker: `Correct!`, `loss=0`, `relative_loss=0.0`, `sse=0.0`
- Post-syn SDF smoke: `Doing SDF annotation ...... Done`, `[POST-SYN] PASS`
- DC target clock: `10.00ns`
- DC setup slack: `9641.00ps`
- Shortest-period latency basis: `359.00ps`
- Score latency: `1,961,600ns`
- Logic area: `4296.081454um^2`
- Logic dynamic power: `0.3437407mW`
- Logic leakage power: `5.0590mW`
- Sparse-aware total power: `5,585,862,556pW`

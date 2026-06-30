.PHONY: default all check_files generate_input precheck check_result syn postcheck clean distclean

PYTHON ?= python3

default: check_files precheck

all: check_files precheck syn postcheck

check_files:
	@test -f rtl/accelerator_top.v
	@test -f rtl/accelerator_logic_top.v
	@test -f rtl/accelerator_sram_ext.v
	@test -f rtl/sram_model.v
	@test -f testbench/common/mem.v
	@test -f testbench/pre-syn/testbench_top.v
	@test -f testbench/post-syn/testbench_top.v
	@test -f syn/syn.tcl
	@test -f input_mem.csv
	@test -f in.npy
	@test -f pdk/NanGate_15nm_OCL_slow_conditional_ccs.db -o -f pdk/NanGate_15nm/front_end/timing_power_noise/CCS/NanGate_15nm_OCL_slow_conditional_ccs.db
	@test -f pdk/NanGate_15nm_OCL_conditional.v -o -f pdk/NanGate_15nm/front_end/verilog/NanGate_15nm_OCL_conditional.v

generate_input:
	$(PYTHON) InputGen.py

precheck:
	cd testbench/pre-syn && make

check_result:
	$(PYTHON) CheckResult.py

syn:
	cd syn && make

postcheck:
	cd testbench/post-syn && make

clean:
	$(MAKE) -C syn clean
	$(MAKE) -C testbench/pre-syn clean
	$(MAKE) -C testbench/post-syn clean
	rm -f ppa_logic_check post_tb_syntax_check sim*.vvp
	rm -rf __pycache__

distclean: clean
	rm -f input_mem.csv result_mem.csv in.npy
	rm -f remote_logs/*.log

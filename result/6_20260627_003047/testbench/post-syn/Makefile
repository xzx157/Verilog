DESIGN = ../../syn/accelerator_logic_top.vg
SDF = ../../syn/accelerator_logic_top_syn.sdf
TESTBENCH = testbench_top.v
SIMV = simv
CELL_LIB_NESTED = ../../pdk/NanGate_15nm/front_end/verilog/NanGate_15nm_OCL_conditional.v
CELL_LIB_FLAT = ../../pdk/NanGate_15nm_OCL_conditional.v

default:
	@if [ ! -f $(DESIGN) ]; then \
		echo "ERROR: $(DESIGN) not found. Run synthesis first."; \
		exit 1; \
	fi; \
	if [ -f $(CELL_LIB_NESTED) ]; then \
		CELL_LIB=$(CELL_LIB_NESTED); \
	elif [ -f $(CELL_LIB_FLAT) ]; then \
		CELL_LIB=$(CELL_LIB_FLAT); \
	else \
		echo "ERROR: NanGate conditional Verilog model not found under ../../pdk"; \
		exit 1; \
	fi; \
	vcs -full64 -sverilog -timescale=1ns/1ps +v2k +define+SDF +define+GATE -o $(SIMV) $(DESIGN) $$CELL_LIB $(TESTBENCH) -l compile.log; \
	./$(SIMV) -l run.log

clean:
	rm -rf $(SIMV) $(SIMV).daidir csrc *.log *.vcd *.vpd *.fsdb ucli.key

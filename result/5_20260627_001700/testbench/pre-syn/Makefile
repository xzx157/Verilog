SRCS = \
	../common/mem.v \
	../../rtl/sram_model.v \
	../../rtl/accelerator_sram_ext.v \
	../../rtl/accelerator_top.v \
	testbench_top.v

default:
	@if command -v iverilog >/dev/null 2>&1; then \
		iverilog -g2012 -Wall -o simv $(SRCS); \
		vvp simv; \
	elif command -v vcs >/dev/null 2>&1; then \
		vcs -full64 -sverilog -timescale=1ns/1ps +v2k -o simv $(SRCS) -l compile.log; \
		./simv -l run.log; \
	else \
		echo "ERROR: neither iverilog nor vcs found"; \
		exit 127; \
	fi

clean:
	rm -rf simv simv.daidir csrc *.log *.vcd *.vpd *.fsdb

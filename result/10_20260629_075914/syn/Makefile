default:
	mkdir -p log
	dc_shell-t -f syn.tcl | tee log/syn_terminal.log

post-syn:
	$(MAKE) -C ../testbench/post-syn

clean:
	rm -f accelerator_logic_top.vg accelerator_logic_top_syn.sdf command.log default.svf
	rm -rf log/*

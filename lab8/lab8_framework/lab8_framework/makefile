
default:
	iverilog -o wave testbench_top.v
	vvp -n wave

clean:
	rm -f ./wave 
	rm -f ./*.vcd 
	rm -f ./result_mem.csv
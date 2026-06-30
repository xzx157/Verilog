default: precheck

generate_input:
	python InputGen.py

precheck:
	cd testbench/pre-syn && make

check_result:
	python CheckResult.py

syn:
	cd syn && make

postcheck:
	cd testbench/post-syn && make

clean:
	cd syn && make clean
	cd testbench/pre-syn && make clean
	cd testbench/post-syn && make clean
	rm -f result_mem.csv simv ppa_logic_check

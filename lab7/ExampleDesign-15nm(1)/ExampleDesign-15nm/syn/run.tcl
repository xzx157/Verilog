
#set top module name
set MAIN_MODULE "ProgramCounter"

#set clock period, unit: ps
set CLK_cycle 2000

#set standard libraries
set link_library "../pdk/NanGate_15nm/front_end/timing_power_noise/CCS/NanGate_15nm_OCL_slow_conditional_ccs.db"
set target_library "../pdk/NanGate_15nm/front_end/timing_power_noise/CCS/NanGate_15nm_OCL_slow_conditional_ccs.db"

#read your verilog in:
read_file -format verilog "../rtl/program_counter.v"

current_design $MAIN_MODULE

link > "log/link.rpt"
check_design > "log/check_design.rpt"

uniquify

set_wire_load_model -name ZeroWireload
set_max_area 0
set_fix_multiple_port_nets -outputs -feedthroughs -buffer_constants

set_load 0.1 [all_outputs]
set_max_transition      500 [current_design_name]
set_max_fanout          16.0 [current_design_name]
create_clock -name "sysclk" -period $CLK_cycle [get_ports clk]
set_clock_uncertainty   100 "sysclk"
set_fix_hold [get_ports clk]
set_ideal_network [get_ports clk]

compile -map_effort medium

write_file -format ddc -hier -o log/WorkSpace.ddc

report_power > "log/power.rpt"
report_area > "log/area.rpt"
report_timing -max_paths 10 > "log/timing.rpt"
write -hier -f verilog -output "${MAIN_MODULE}.vg"
write_sdf -version 2.1 "${MAIN_MODULE}_syn.sdf"

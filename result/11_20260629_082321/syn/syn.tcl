# Logic-only synthesis target for PPA.
# Excludes SRAM macro instances, top controller, input memory, result memory, and data memory.

set MAIN_MODULE "accelerator_logic_top"
set CLK_cycle 1000

set PDK_DB_CANDIDATES [list \
    "../pdk/NanGate_15nm/front_end/timing_power_noise/CCS/NanGate_15nm_OCL_slow_conditional_ccs.db" \
    "../pdk/NanGate_15nm_OCL_slow_conditional_ccs.db" \
]

set PDK_DB ""
foreach candidate $PDK_DB_CANDIDATES {
    if {[file exists $candidate]} {
        set PDK_DB $candidate
        break
    }
}

if {$PDK_DB eq ""} {
    puts "ERROR: Cannot find NanGate db. Checked: $PDK_DB_CANDIDATES"
    exit 2
}

set link_library $PDK_DB
set target_library $PDK_DB

read_file -format sverilog [list \
    "../rtl/accelerator_sram_ext.v" \
    "../rtl/accelerator_logic_top.v" \
]

current_design $MAIN_MODULE
link > "log/link.rpt"
check_design > "log/check_design.rpt"

uniquify

catch {set_wire_load_model -name ZeroWireload}
set_max_area 0
set_fix_multiple_port_nets -outputs -feedthroughs -buffer_constants

set_load 0.1 [all_outputs]
set_max_transition 500 [current_design_name]
set_max_fanout 16.0 [current_design_name]

create_clock -name "sysclk" -period $CLK_cycle [get_ports clk]
set_clock_uncertainty 100 "sysclk"
set_ideal_network [get_ports clk]

catch {set_clock_gating_style -positive_edge_logic integrated -negative_edge_logic integrated -control_point before}
compile -gate_clock -map_effort high -area_effort high

write_file -format ddc -hier -o "log/WorkSpace.ddc"

report_power > "log/power.rpt"
report_area > "log/area.rpt"
report_timing -max_paths 10 > "log/timing.rpt"
report_constraint -all_violators > "log/constraints.rpt"

write -hier -f verilog -output "${MAIN_MODULE}.vg"
write_sdf -version 2.1 "${MAIN_MODULE}_syn.sdf"
exit

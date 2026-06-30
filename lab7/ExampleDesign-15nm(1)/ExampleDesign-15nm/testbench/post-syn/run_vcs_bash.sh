#!/bin/bash
# VCS Simulation Script (Bash Version)
# Used to compile and run the ProgramCounter testbench

# Set variables
DESIGN_FILE="../../syn/ProgramCounter.vg ../../pdk/NanGate_15nm/front_end/verilog/NanGate_15nm_OCL_conditional.v"          # Design file
TESTBENCH_FILE="testbench.v"            # Testbench file
SIMV_NAME="simv"                        # Simulation executable name
LOG_FILE="compile.log"                  # Compilation log file
RUN_LOG="run.log"                       # Run log file

# Clean up previous simulation files
echo "Cleaning up previous simulation files..."
rm -rf csrc $SIMV_NAME $SIMV_NAME.daidir *.log *.vpd *.fsdb >/dev/null 2>&1

# Compile design and testbench
echo "Compiling design and testbench with VCS..."
vcs -full64 \
    -sverilog \
    -debug_access+all \
    -timescale=1ns/1ps \
    +v2k \
    +define+VCS \
    -o $SIMV_NAME \
    $DESIGN_FILE \
    $TESTBENCH_FILE \
    -l $LOG_FILE

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo "Compilation log saved to $LOG_FILE"
else
    echo "Compilation failed! Check $LOG_FILE for details."
    exit 1
fi

# Run simulation
echo "Running simulation..."
./$SIMV_NAME -l $RUN_LOG

# Check if simulation was successful
if [ $? -eq 0 ]; then
    echo "Simulation completed successfully!"
    echo "Simulation log saved to $RUN_LOG"
else
    echo "Simulation failed! Check $RUN_LOG for details."
    exit 1
fi

echo ""
echo "==================================================================="
echo "Simulation completed."
echo "==================================================================="
exit 0
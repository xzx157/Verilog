Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot
iverilog -g2012 -Wall -o simv `
    ../common/mem.v `
    ../../rtl/sram_model.v `
    ../../rtl/accelerator_sram_ext.v `
    ../../rtl/accelerator_top.v `
    testbench_top.v
vvp simv

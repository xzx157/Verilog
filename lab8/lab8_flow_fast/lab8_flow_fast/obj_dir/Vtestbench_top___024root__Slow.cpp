// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtestbench_top.h for the primary calling header

#include "Vtestbench_top__pch.h"
#include "Vtestbench_top__Syms.h"
#include "Vtestbench_top___024root.h"

void Vtestbench_top___024root___ctor_var_reset(Vtestbench_top___024root* vlSelf);

Vtestbench_top___024root::Vtestbench_top___024root(Vtestbench_top__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtestbench_top___024root___ctor_var_reset(this);
}

void Vtestbench_top___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtestbench_top___024root::~Vtestbench_top___024root() {
}

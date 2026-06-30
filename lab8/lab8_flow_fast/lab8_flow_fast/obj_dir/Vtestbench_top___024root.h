// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtestbench_top.h for the primary calling header

#ifndef VERILATED_VTESTBENCH_TOP___024ROOT_H_
#define VERILATED_VTESTBENCH_TOP___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtestbench_top__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtestbench_top___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ testbench_top__DOT__clk;
    CData/*0:0*/ testbench_top__DOT__mem_write_enb;
    CData/*0:0*/ testbench_top__DOT____Vcellinp__u_input_mem__web;
    CData/*0:0*/ testbench_top__DOT__comp_enb;
    CData/*3:0*/ testbench_top__DOT__mem_addr;
    CData/*0:0*/ testbench_top__DOT__mem_read_enb;
    CData/*3:0*/ testbench_top__DOT__res_addr;
    CData/*0:0*/ testbench_top__DOT__busyb;
    CData/*0:0*/ testbench_top__DOT__done;
    CData/*1:0*/ testbench_top__DOT__u_accelerator__DOT__state;
    CData/*1:0*/ testbench_top__DOT__u_accelerator__DOT__counter;
    CData/*1:0*/ __Vdly__testbench_top__DOT__u_accelerator__DOT__state;
    CData/*1:0*/ __Vdly__testbench_top__DOT__u_accelerator__DOT__counter;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__testbench_top__DOT__clk__0;
    CData/*1:0*/ __Vtrigprevexpr___TOP__testbench_top__DOT__u_accelerator__DOT__state__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__testbench_top__DOT____Vcellinp__u_input_mem__web__0;
    CData/*3:0*/ __Vtrigprevexpr___TOP__testbench_top__DOT__mem_addr__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__testbench_top__DOT__mem_write_enb__0;
    CData/*3:0*/ __Vtrigprevexpr___TOP__testbench_top__DOT__res_addr__0;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ testbench_top__DOT__i;
    IData/*31:0*/ testbench_top__DOT__file1;
    IData/*31:0*/ __VactIterCount;
    QData/*63:0*/ testbench_top__DOT__res_data;
    QData/*63:0*/ testbench_top__DOT__u_accelerator__DOT__reg1;
    QData/*63:0*/ testbench_top__DOT__u_accelerator__DOT__reg2;
    QData/*63:0*/ testbench_top__DOT__u_input_mem__DOT__d;
    QData/*63:0*/ testbench_top__DOT__u_input_mem__DOT__data_out;
    QData/*63:0*/ testbench_top__DOT__u_res_mem__DOT__data_out;
    QData/*63:0*/ __Vdly__testbench_top__DOT__u_accelerator__DOT__reg1;
    QData/*63:0*/ __Vdly__testbench_top__DOT__u_accelerator__DOT__reg2;
    VlUnpacked<QData/*63:0*/, 16> testbench_top__DOT__u_input_mem__DOT__mem;
    VlUnpacked<QData/*63:0*/, 16> testbench_top__DOT__u_res_mem__DOT__mem;
    VlUnpacked<CData/*0:0*/, 5> __Vm_traceActivity;
    VlDelayScheduler __VdlySched;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<5> __VactTriggered;
    VlTriggerVec<5> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtestbench_top__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtestbench_top___024root(Vtestbench_top__Syms* symsp, const char* v__name);
    ~Vtestbench_top___024root();
    VL_UNCOPYABLE(Vtestbench_top___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard

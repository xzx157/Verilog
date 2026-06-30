// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtestbench_top.h for the primary calling header

#include "Vtestbench_top__pch.h"
#include "Vtestbench_top___024root.h"

VL_ATTR_COLD void Vtestbench_top___024root___eval_static__TOP(Vtestbench_top___024root* vlSelf);

VL_ATTR_COLD void Vtestbench_top___024root___eval_static(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_static\n"); );
    // Body
    Vtestbench_top___024root___eval_static__TOP(vlSelf);
}

VL_ATTR_COLD void Vtestbench_top___024root___eval_static__TOP(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_static__TOP\n"); );
    // Body
    vlSelf->testbench_top__DOT__clk = 0U;
}

VL_ATTR_COLD void Vtestbench_top___024root___eval_final(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtestbench_top___024root___dump_triggers__stl(Vtestbench_top___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtestbench_top___024root___eval_phase__stl(Vtestbench_top___024root* vlSelf);

VL_ATTR_COLD void Vtestbench_top___024root___eval_settle(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_settle\n"); );
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelf->__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vtestbench_top___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("testbench_top.v", 7, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vtestbench_top___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtestbench_top___024root___dump_triggers__stl(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtestbench_top___024root___stl_sequent__TOP__0(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___stl_sequent__TOP__0\n"); );
    // Body
    vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web 
        = (1U & (~ (IData)(vlSelf->testbench_top__DOT__mem_read_enb)));
}

VL_ATTR_COLD void Vtestbench_top___024root___eval_stl(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vtestbench_top___024root___stl_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[4U] = 1U;
        vlSelf->__Vm_traceActivity[3U] = 1U;
        vlSelf->__Vm_traceActivity[2U] = 1U;
        vlSelf->__Vm_traceActivity[1U] = 1U;
        vlSelf->__Vm_traceActivity[0U] = 1U;
    }
}

VL_ATTR_COLD void Vtestbench_top___024root___eval_triggers__stl(Vtestbench_top___024root* vlSelf);

VL_ATTR_COLD bool Vtestbench_top___024root___eval_phase__stl(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtestbench_top___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vtestbench_top___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtestbench_top___024root___dump_triggers__act(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge testbench_top.clk)\n");
    }
    if ((2ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @([changed] testbench_top.u_accelerator.state)\n");
    }
    if ((4ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @([changed] testbench_top.__Vcellinp__u_input_mem__web or [changed] testbench_top.mem_addr)\n");
    }
    if ((8ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 3 is active: @([changed] testbench_top.mem_write_enb or [changed] testbench_top.res_addr)\n");
    }
    if ((0x10ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 4 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtestbench_top___024root___dump_triggers__nba(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge testbench_top.clk)\n");
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @([changed] testbench_top.u_accelerator.state)\n");
    }
    if ((4ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @([changed] testbench_top.__Vcellinp__u_input_mem__web or [changed] testbench_top.mem_addr)\n");
    }
    if ((8ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 3 is active: @([changed] testbench_top.mem_write_enb or [changed] testbench_top.res_addr)\n");
    }
    if ((0x10ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 4 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtestbench_top___024root___ctor_var_reset(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->testbench_top__DOT__i = VL_RAND_RESET_I(32);
    vlSelf->testbench_top__DOT__file1 = 0;
    vlSelf->testbench_top__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->testbench_top__DOT__comp_enb = VL_RAND_RESET_I(1);
    vlSelf->testbench_top__DOT__mem_addr = VL_RAND_RESET_I(4);
    vlSelf->testbench_top__DOT__mem_read_enb = VL_RAND_RESET_I(1);
    vlSelf->testbench_top__DOT__mem_write_enb = VL_RAND_RESET_I(1);
    vlSelf->testbench_top__DOT__res_addr = VL_RAND_RESET_I(4);
    vlSelf->testbench_top__DOT__res_data = VL_RAND_RESET_Q(64);
    vlSelf->testbench_top__DOT__busyb = VL_RAND_RESET_I(1);
    vlSelf->testbench_top__DOT__done = VL_RAND_RESET_I(1);
    vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web = VL_RAND_RESET_I(1);
    vlSelf->testbench_top__DOT__u_accelerator__DOT__state = VL_RAND_RESET_I(2);
    vlSelf->testbench_top__DOT__u_accelerator__DOT__counter = VL_RAND_RESET_I(2);
    vlSelf->testbench_top__DOT__u_accelerator__DOT__reg1 = VL_RAND_RESET_Q(64);
    vlSelf->testbench_top__DOT__u_accelerator__DOT__reg2 = VL_RAND_RESET_Q(64);
    vlSelf->testbench_top__DOT__u_input_mem__DOT__d = VL_RAND_RESET_Q(64);
    vlSelf->testbench_top__DOT__u_input_mem__DOT__data_out = VL_RAND_RESET_Q(64);
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[__Vi0] = VL_RAND_RESET_Q(64);
    }
    vlSelf->testbench_top__DOT__u_res_mem__DOT__data_out = VL_RAND_RESET_Q(64);
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[__Vi0] = VL_RAND_RESET_Q(64);
    }
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state = VL_RAND_RESET_I(2);
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg1 = VL_RAND_RESET_Q(64);
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg2 = VL_RAND_RESET_Q(64);
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter = VL_RAND_RESET_I(2);
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__u_accelerator__DOT__state__0 = VL_RAND_RESET_I(2);
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT____Vcellinp__u_input_mem__web__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__mem_addr__0 = VL_RAND_RESET_I(4);
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__mem_write_enb__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__res_addr__0 = VL_RAND_RESET_I(4);
    vlSelf->__VactDidInit = 0;
    for (int __Vi0 = 0; __Vi0 < 5; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}

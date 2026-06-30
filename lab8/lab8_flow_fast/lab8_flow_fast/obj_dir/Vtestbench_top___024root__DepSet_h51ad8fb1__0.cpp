// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtestbench_top.h for the primary calling header

#include "Vtestbench_top__pch.h"
#include "Vtestbench_top__Syms.h"
#include "Vtestbench_top___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtestbench_top___024root___dump_triggers__act(Vtestbench_top___024root* vlSelf);
#endif  // VL_DEBUG

void Vtestbench_top___024root___eval_triggers__act(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->testbench_top__DOT__clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__clk__0))));
    vlSelf->__VactTriggered.set(1U, ((IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state) 
                                     != (IData)(vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__u_accelerator__DOT__state__0)));
    vlSelf->__VactTriggered.set(2U, (((IData)(vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web) 
                                      != (IData)(vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT____Vcellinp__u_input_mem__web__0)) 
                                     | ((IData)(vlSelf->testbench_top__DOT__mem_addr) 
                                        != (IData)(vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__mem_addr__0))));
    vlSelf->__VactTriggered.set(3U, (((IData)(vlSelf->testbench_top__DOT__mem_write_enb) 
                                      != (IData)(vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__mem_write_enb__0)) 
                                     | ((IData)(vlSelf->testbench_top__DOT__res_addr) 
                                        != (IData)(vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__res_addr__0))));
    vlSelf->__VactTriggered.set(4U, vlSelf->__VdlySched.awaitingCurrentTime());
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__clk__0 
        = vlSelf->testbench_top__DOT__clk;
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__u_accelerator__DOT__state__0 
        = vlSelf->testbench_top__DOT__u_accelerator__DOT__state;
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT____Vcellinp__u_input_mem__web__0 
        = vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web;
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__mem_addr__0 
        = vlSelf->testbench_top__DOT__mem_addr;
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__mem_write_enb__0 
        = vlSelf->testbench_top__DOT__mem_write_enb;
    vlSelf->__Vtrigprevexpr___TOP__testbench_top__DOT__res_addr__0 
        = vlSelf->testbench_top__DOT__res_addr;
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelf->__VactDidInit))))) {
        vlSelf->__VactDidInit = 1U;
        vlSelf->__VactTriggered.set(1U, 1U);
        vlSelf->__VactTriggered.set(2U, 1U);
        vlSelf->__VactTriggered.set(3U, 1U);
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtestbench_top___024root___dump_triggers__act(vlSelf);
    }
#endif
}

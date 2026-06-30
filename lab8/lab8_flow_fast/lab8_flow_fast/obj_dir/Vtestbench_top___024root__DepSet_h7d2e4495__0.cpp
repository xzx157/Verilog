// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtestbench_top.h for the primary calling header

#include "Vtestbench_top__pch.h"
#include "Vtestbench_top___024root.h"

VlCoroutine Vtestbench_top___024root___eval_initial__TOP__Vtiming__0(Vtestbench_top___024root* vlSelf);
VlCoroutine Vtestbench_top___024root___eval_initial__TOP__Vtiming__1(Vtestbench_top___024root* vlSelf);

void Vtestbench_top___024root___eval_initial(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vm_traceActivity[1U] = 1U;
    Vtestbench_top___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vtestbench_top___024root___eval_initial__TOP__Vtiming__1(vlSelf);
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
}

VL_INLINE_OPT VlCoroutine Vtestbench_top___024root___eval_initial__TOP__Vtiming__0(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_initial__TOP__Vtiming__0\n"); );
    // Init
    VlWide<4>/*127:0*/ __Vtemp_1;
    VlWide<4>/*127:0*/ __Vtemp_2;
    // Body
    __Vtemp_1[0U] = 0x2e637376U;
    __Vtemp_1[1U] = 0x5f6d656dU;
    __Vtemp_1[2U] = 0x6e707574U;
    __Vtemp_1[3U] = 0x69U;
    VL_READMEM_N(true, 64, 16, 0, VL_CVT_PACK_STR_NW(4, __Vtemp_1)
                 ,  &(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem)
                 , 0, ~0ULL);
    vlSelf->testbench_top__DOT__comp_enb = 1U;
    co_await vlSelf->__VdlySched.delay(2ULL, nullptr, 
                                       "testbench_top.v", 
                                       63);
    vlSelf->__Vm_traceActivity[2U] = 1U;
    vlSelf->testbench_top__DOT__comp_enb = 0U;
    co_await vlSelf->__VdlySched.delay(0x14ULL, nullptr, 
                                       "testbench_top.v", 
                                       66);
    vlSelf->__Vm_traceActivity[2U] = 1U;
    __Vtemp_2[0U] = 0x2e637376U;
    __Vtemp_2[1U] = 0x5f6d656dU;
    __Vtemp_2[2U] = 0x73756c74U;
    __Vtemp_2[3U] = 0x7265U;
    vlSelf->testbench_top__DOT__file1 = VL_FOPEN_NN(
                                                    VL_CVT_PACK_STR_NW(4, __Vtemp_2)
                                                    , 
                                                    std::string{"w"});
    ;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [0U]);
    vlSelf->testbench_top__DOT__i = 1U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [1U]);
    vlSelf->testbench_top__DOT__i = 2U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [2U]);
    vlSelf->testbench_top__DOT__i = 3U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [3U]);
    vlSelf->testbench_top__DOT__i = 4U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [4U]);
    vlSelf->testbench_top__DOT__i = 5U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [5U]);
    vlSelf->testbench_top__DOT__i = 6U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [6U]);
    vlSelf->testbench_top__DOT__i = 7U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [7U]);
    vlSelf->testbench_top__DOT__i = 8U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [8U]);
    vlSelf->testbench_top__DOT__i = 9U;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [9U]);
    vlSelf->testbench_top__DOT__i = 0xaU;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [0xaU]);
    vlSelf->testbench_top__DOT__i = 0xbU;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [0xbU]);
    vlSelf->testbench_top__DOT__i = 0xcU;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [0xcU]);
    vlSelf->testbench_top__DOT__i = 0xdU;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [0xdU]);
    vlSelf->testbench_top__DOT__i = 0xeU;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [0xeU]);
    vlSelf->testbench_top__DOT__i = 0xfU;
    VL_FWRITEF(vlSelf->testbench_top__DOT__file1,"%8x\n",
               64,vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
               [0xfU]);
    vlSelf->testbench_top__DOT__i = 0x10U;
    VL_FCLOSE_I(vlSelf->testbench_top__DOT__file1); VL_FINISH_MT("testbench_top.v", 72, "");
    vlSelf->__Vm_traceActivity[2U] = 1U;
}

VL_INLINE_OPT VlCoroutine Vtestbench_top___024root___eval_initial__TOP__Vtiming__1(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_initial__TOP__Vtiming__1\n"); );
    // Body
    while (1U) {
        co_await vlSelf->__VdlySched.delay(1ULL, nullptr, 
                                           "testbench_top.v", 
                                           11);
        vlSelf->testbench_top__DOT__clk = (1U & (~ (IData)(vlSelf->testbench_top__DOT__clk)));
    }
}

void Vtestbench_top___024root___eval_act(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vtestbench_top___024root___nba_sequent__TOP__0(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter 
        = vlSelf->testbench_top__DOT__u_accelerator__DOT__counter;
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg2 
        = vlSelf->testbench_top__DOT__u_accelerator__DOT__reg2;
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg1 
        = vlSelf->testbench_top__DOT__u_accelerator__DOT__reg1;
    vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state 
        = vlSelf->testbench_top__DOT__u_accelerator__DOT__state;
    if ((1U & (~ (IData)(vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web)))) {
        vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[vlSelf->testbench_top__DOT__mem_addr] 
            = vlSelf->testbench_top__DOT__u_input_mem__DOT__d;
    }
    if ((1U & (~ (IData)(vlSelf->testbench_top__DOT__mem_write_enb)))) {
        vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[vlSelf->testbench_top__DOT__res_addr] 
            = vlSelf->testbench_top__DOT__res_data;
    }
    if (vlSelf->testbench_top__DOT__comp_enb) {
        vlSelf->testbench_top__DOT__mem_read_enb = 0U;
    }
}

VL_INLINE_OPT void Vtestbench_top___024root___nba_sequent__TOP__1(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___nba_sequent__TOP__1\n"); );
    // Body
    vlSelf->testbench_top__DOT__done = ((2U != (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state)) 
                                        && (3U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state)));
    vlSelf->testbench_top__DOT__busyb = ((2U != (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state)) 
                                         && (3U != (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state)));
}

VL_INLINE_OPT void Vtestbench_top___024root___nba_sequent__TOP__2(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___nba_sequent__TOP__2\n"); );
    // Body
    if (vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web) {
        vlSelf->testbench_top__DOT__u_input_mem__DOT__data_out 
            = vlSelf->testbench_top__DOT__u_input_mem__DOT__mem
            [vlSelf->testbench_top__DOT__mem_addr];
    }
}

VL_INLINE_OPT void Vtestbench_top___024root___nba_sequent__TOP__3(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___nba_sequent__TOP__3\n"); );
    // Body
    if (vlSelf->testbench_top__DOT__mem_write_enb) {
        vlSelf->testbench_top__DOT__u_res_mem__DOT__data_out 
            = vlSelf->testbench_top__DOT__u_res_mem__DOT__mem
            [vlSelf->testbench_top__DOT__res_addr];
    }
}

VL_INLINE_OPT void Vtestbench_top___024root___nba_sequent__TOP__4(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___nba_sequent__TOP__4\n"); );
    // Body
    vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web 
        = (1U & (~ (IData)(vlSelf->testbench_top__DOT__mem_read_enb)));
    if (vlSelf->testbench_top__DOT__comp_enb) {
        vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state = 0U;
        vlSelf->testbench_top__DOT__res_addr = 0U;
        vlSelf->testbench_top__DOT__res_data = 0ULL;
        vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg1 = 0ULL;
        vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg2 = 0ULL;
        vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter = 0U;
        vlSelf->testbench_top__DOT__mem_write_enb = 1U;
    } else if ((0U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state))) {
        if ((1U & (~ (IData)(vlSelf->testbench_top__DOT__comp_enb)))) {
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state = 1U;
        }
    } else if ((1U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state))) {
        if ((0U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter))) {
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter 
                = (3U & ((IData)(1U) + (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter)));
            vlSelf->testbench_top__DOT__mem_addr = 0U;
        } else if ((1U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter))) {
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter 
                = (3U & ((IData)(1U) + (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter)));
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg1 
                = vlSelf->testbench_top__DOT__u_input_mem__DOT__data_out;
            vlSelf->testbench_top__DOT__mem_addr = 1U;
        } else if ((2U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter))) {
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg2 
                = vlSelf->testbench_top__DOT__u_input_mem__DOT__data_out;
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter = 0U;
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state = 2U;
        }
    } else if ((2U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__state))) {
        if ((0U == (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter))) {
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter 
                = (3U & ((IData)(1U) + (IData)(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter)));
            vlSelf->testbench_top__DOT__mem_write_enb = 0U;
            vlSelf->testbench_top__DOT__res_addr = 2U;
            vlSelf->testbench_top__DOT__res_data = 
                (vlSelf->testbench_top__DOT__u_accelerator__DOT__reg1 
                 + vlSelf->testbench_top__DOT__u_accelerator__DOT__reg2);
        } else {
            vlSelf->testbench_top__DOT__mem_write_enb = 1U;
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter = 0U;
            vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state = 3U;
        }
    } else if (vlSelf->testbench_top__DOT__comp_enb) {
        vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state = 0U;
    }
    vlSelf->testbench_top__DOT__u_accelerator__DOT__reg1 
        = vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg1;
    vlSelf->testbench_top__DOT__u_accelerator__DOT__reg2 
        = vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__reg2;
    vlSelf->testbench_top__DOT__u_accelerator__DOT__counter 
        = vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__counter;
    vlSelf->testbench_top__DOT__u_accelerator__DOT__state 
        = vlSelf->__Vdly__testbench_top__DOT__u_accelerator__DOT__state;
}

void Vtestbench_top___024root___eval_nba(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtestbench_top___024root___nba_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[3U] = 1U;
    }
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtestbench_top___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((4ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtestbench_top___024root___nba_sequent__TOP__2(vlSelf);
    }
    if ((8ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtestbench_top___024root___nba_sequent__TOP__3(vlSelf);
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtestbench_top___024root___nba_sequent__TOP__4(vlSelf);
        vlSelf->__Vm_traceActivity[4U] = 1U;
    }
}

void Vtestbench_top___024root___timing_resume(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___timing_resume\n"); );
    // Body
    if ((0x10ULL & vlSelf->__VactTriggered.word(0U))) {
        vlSelf->__VdlySched.resume();
    }
}

void Vtestbench_top___024root___eval_triggers__act(Vtestbench_top___024root* vlSelf);

bool Vtestbench_top___024root___eval_phase__act(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<5> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vtestbench_top___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vtestbench_top___024root___timing_resume(vlSelf);
        Vtestbench_top___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtestbench_top___024root___eval_phase__nba(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vtestbench_top___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtestbench_top___024root___dump_triggers__nba(Vtestbench_top___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtestbench_top___024root___dump_triggers__act(Vtestbench_top___024root* vlSelf);
#endif  // VL_DEBUG

void Vtestbench_top___024root___eval(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vtestbench_top___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("testbench_top.v", 7, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vtestbench_top___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("testbench_top.v", 7, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vtestbench_top___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vtestbench_top___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vtestbench_top___024root___eval_debug_assertions(Vtestbench_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root___eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG

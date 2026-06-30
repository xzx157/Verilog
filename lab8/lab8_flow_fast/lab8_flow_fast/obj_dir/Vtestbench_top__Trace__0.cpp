// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtestbench_top__Syms.h"


void Vtestbench_top___024root__trace_chg_0_sub_0(Vtestbench_top___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtestbench_top___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_chg_0\n"); );
    // Init
    Vtestbench_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtestbench_top___024root*>(voidSelf);
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtestbench_top___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtestbench_top___024root__trace_chg_0_sub_0(Vtestbench_top___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(((vlSelf->__Vm_traceActivity[1U] 
                      | vlSelf->__Vm_traceActivity[2U]) 
                     | vlSelf->__Vm_traceActivity[3U]))) {
        bufp->chgQData(oldp+0,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[0]),64);
        bufp->chgQData(oldp+2,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[1]),64);
        bufp->chgQData(oldp+4,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[2]),64);
        bufp->chgQData(oldp+6,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[3]),64);
        bufp->chgQData(oldp+8,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[4]),64);
        bufp->chgQData(oldp+10,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[5]),64);
        bufp->chgQData(oldp+12,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[6]),64);
        bufp->chgQData(oldp+14,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[7]),64);
        bufp->chgQData(oldp+16,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[8]),64);
        bufp->chgQData(oldp+18,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[9]),64);
        bufp->chgQData(oldp+20,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[10]),64);
        bufp->chgQData(oldp+22,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[11]),64);
        bufp->chgQData(oldp+24,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[12]),64);
        bufp->chgQData(oldp+26,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[13]),64);
        bufp->chgQData(oldp+28,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[14]),64);
        bufp->chgQData(oldp+30,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[15]),64);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[3U])) {
        bufp->chgBit(oldp+32,(vlSelf->testbench_top__DOT__mem_read_enb));
        bufp->chgQData(oldp+33,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[0]),64);
        bufp->chgQData(oldp+35,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[1]),64);
        bufp->chgQData(oldp+37,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[2]),64);
        bufp->chgQData(oldp+39,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[3]),64);
        bufp->chgQData(oldp+41,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[4]),64);
        bufp->chgQData(oldp+43,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[5]),64);
        bufp->chgQData(oldp+45,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[6]),64);
        bufp->chgQData(oldp+47,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[7]),64);
        bufp->chgQData(oldp+49,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[8]),64);
        bufp->chgQData(oldp+51,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[9]),64);
        bufp->chgQData(oldp+53,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[10]),64);
        bufp->chgQData(oldp+55,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[11]),64);
        bufp->chgQData(oldp+57,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[12]),64);
        bufp->chgQData(oldp+59,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[13]),64);
        bufp->chgQData(oldp+61,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[14]),64);
        bufp->chgQData(oldp+63,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[15]),64);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[4U])) {
        bufp->chgCData(oldp+65,(vlSelf->testbench_top__DOT__mem_addr),4);
        bufp->chgBit(oldp+66,(vlSelf->testbench_top__DOT__mem_write_enb));
        bufp->chgCData(oldp+67,(vlSelf->testbench_top__DOT__res_addr),4);
        bufp->chgQData(oldp+68,(vlSelf->testbench_top__DOT__res_data),64);
        bufp->chgCData(oldp+70,(vlSelf->testbench_top__DOT__u_accelerator__DOT__state),2);
        bufp->chgCData(oldp+71,(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter),2);
        bufp->chgQData(oldp+72,(vlSelf->testbench_top__DOT__u_accelerator__DOT__reg1),64);
        bufp->chgQData(oldp+74,(vlSelf->testbench_top__DOT__u_accelerator__DOT__reg2),64);
        bufp->chgBit(oldp+76,(vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web));
    }
    bufp->chgIData(oldp+77,(vlSelf->testbench_top__DOT__i),32);
    bufp->chgIData(oldp+78,(vlSelf->testbench_top__DOT__file1),32);
    bufp->chgBit(oldp+79,(vlSelf->testbench_top__DOT__clk));
    bufp->chgBit(oldp+80,(vlSelf->testbench_top__DOT__comp_enb));
    bufp->chgQData(oldp+81,(vlSelf->testbench_top__DOT__u_input_mem__DOT__data_out),64);
    bufp->chgBit(oldp+83,(vlSelf->testbench_top__DOT__busyb));
    bufp->chgBit(oldp+84,(vlSelf->testbench_top__DOT__done));
    bufp->chgQData(oldp+85,(vlSelf->testbench_top__DOT__u_res_mem__DOT__data_out),64);
}

void Vtestbench_top___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_cleanup\n"); );
    // Init
    Vtestbench_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtestbench_top___024root*>(voidSelf);
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[4U] = 0U;
}

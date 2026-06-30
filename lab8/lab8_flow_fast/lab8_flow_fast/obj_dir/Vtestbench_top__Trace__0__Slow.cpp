// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtestbench_top__Syms.h"


VL_ATTR_COLD void Vtestbench_top___024root__trace_init_sub__TOP__0(Vtestbench_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->pushPrefix("testbench_top", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+78,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->declBus(c+79,0,"file1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INTEGER, false,-1, 31,0);
    tracep->declBit(c+80,0,"clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"comp_enb",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+66,0,"mem_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declQuad(c+82,0,"mem_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+33,0,"mem_read_enb",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+67,0,"mem_write_enb",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+68,0,"res_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declQuad(c+69,0,"res_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+84,0,"busyb",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+85,0,"done",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("u_accelerator", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+80,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"comp_enb",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+66,0,"mem_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declQuad(c+82,0,"mem_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+33,0,"mem_read_enb",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+67,0,"mem_write_enb",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+68,0,"res_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declQuad(c+69,0,"res_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+84,0,"busyb",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+85,0,"done",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+88,0,"S_RST",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+89,0,"S_READ",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+90,0,"S_WORK",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+91,0,"S_DONE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+71,0,"state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+72,0,"counter",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declQuad(c+73,0,"reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declQuad(c+75,0,"reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_input_mem", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+92,0,"DATA_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+93,0,"ADDR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+94,0,"RAM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+80,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+66,0,"address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBit(c+95,0,"cs",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+77,0,"web",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+96,0,"d",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declQuad(c+82,0,"q",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declQuad(c+82,0,"data_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->pushPrefix("mem", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 16; ++i) {
        tracep->declQuad(c+1+i*2,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 63,0);
    }
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("u_res_mem", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+92,0,"DATA_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+93,0,"ADDR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+94,0,"RAM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+80,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+68,0,"address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBit(c+95,0,"cs",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+67,0,"web",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+69,0,"d",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declQuad(c+86,0,"q",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declQuad(c+86,0,"data_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->pushPrefix("mem", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 16; ++i) {
        tracep->declQuad(c+34+i*2,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 63,0);
    }
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vtestbench_top___024root__trace_init_top(Vtestbench_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_init_top\n"); );
    // Body
    Vtestbench_top___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtestbench_top___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vtestbench_top___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtestbench_top___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtestbench_top___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtestbench_top___024root__trace_register(Vtestbench_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_register\n"); );
    // Body
    tracep->addConstCb(&Vtestbench_top___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vtestbench_top___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vtestbench_top___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vtestbench_top___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtestbench_top___024root__trace_const_0_sub_0(Vtestbench_top___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtestbench_top___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_const_0\n"); );
    // Init
    Vtestbench_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtestbench_top___024root*>(voidSelf);
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vtestbench_top___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtestbench_top___024root__trace_const_0_sub_0(Vtestbench_top___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_const_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+88,(0U),32);
    bufp->fullIData(oldp+89,(1U),32);
    bufp->fullIData(oldp+90,(2U),32);
    bufp->fullIData(oldp+91,(3U),32);
    bufp->fullIData(oldp+92,(0x40U),32);
    bufp->fullIData(oldp+93,(4U),32);
    bufp->fullIData(oldp+94,(0x10U),32);
    bufp->fullBit(oldp+95,(1U));
    bufp->fullQData(oldp+96,(vlSelf->testbench_top__DOT__u_input_mem__DOT__d),64);
}

VL_ATTR_COLD void Vtestbench_top___024root__trace_full_0_sub_0(Vtestbench_top___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtestbench_top___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_full_0\n"); );
    // Init
    Vtestbench_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtestbench_top___024root*>(voidSelf);
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vtestbench_top___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtestbench_top___024root__trace_full_0_sub_0(Vtestbench_top___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtestbench_top___024root__trace_full_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullQData(oldp+1,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[0]),64);
    bufp->fullQData(oldp+3,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[1]),64);
    bufp->fullQData(oldp+5,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[2]),64);
    bufp->fullQData(oldp+7,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[3]),64);
    bufp->fullQData(oldp+9,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[4]),64);
    bufp->fullQData(oldp+11,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[5]),64);
    bufp->fullQData(oldp+13,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[6]),64);
    bufp->fullQData(oldp+15,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[7]),64);
    bufp->fullQData(oldp+17,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[8]),64);
    bufp->fullQData(oldp+19,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[9]),64);
    bufp->fullQData(oldp+21,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[10]),64);
    bufp->fullQData(oldp+23,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[11]),64);
    bufp->fullQData(oldp+25,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[12]),64);
    bufp->fullQData(oldp+27,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[13]),64);
    bufp->fullQData(oldp+29,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[14]),64);
    bufp->fullQData(oldp+31,(vlSelf->testbench_top__DOT__u_input_mem__DOT__mem[15]),64);
    bufp->fullBit(oldp+33,(vlSelf->testbench_top__DOT__mem_read_enb));
    bufp->fullQData(oldp+34,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[0]),64);
    bufp->fullQData(oldp+36,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[1]),64);
    bufp->fullQData(oldp+38,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[2]),64);
    bufp->fullQData(oldp+40,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[3]),64);
    bufp->fullQData(oldp+42,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[4]),64);
    bufp->fullQData(oldp+44,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[5]),64);
    bufp->fullQData(oldp+46,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[6]),64);
    bufp->fullQData(oldp+48,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[7]),64);
    bufp->fullQData(oldp+50,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[8]),64);
    bufp->fullQData(oldp+52,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[9]),64);
    bufp->fullQData(oldp+54,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[10]),64);
    bufp->fullQData(oldp+56,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[11]),64);
    bufp->fullQData(oldp+58,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[12]),64);
    bufp->fullQData(oldp+60,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[13]),64);
    bufp->fullQData(oldp+62,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[14]),64);
    bufp->fullQData(oldp+64,(vlSelf->testbench_top__DOT__u_res_mem__DOT__mem[15]),64);
    bufp->fullCData(oldp+66,(vlSelf->testbench_top__DOT__mem_addr),4);
    bufp->fullBit(oldp+67,(vlSelf->testbench_top__DOT__mem_write_enb));
    bufp->fullCData(oldp+68,(vlSelf->testbench_top__DOT__res_addr),4);
    bufp->fullQData(oldp+69,(vlSelf->testbench_top__DOT__res_data),64);
    bufp->fullCData(oldp+71,(vlSelf->testbench_top__DOT__u_accelerator__DOT__state),2);
    bufp->fullCData(oldp+72,(vlSelf->testbench_top__DOT__u_accelerator__DOT__counter),2);
    bufp->fullQData(oldp+73,(vlSelf->testbench_top__DOT__u_accelerator__DOT__reg1),64);
    bufp->fullQData(oldp+75,(vlSelf->testbench_top__DOT__u_accelerator__DOT__reg2),64);
    bufp->fullBit(oldp+77,(vlSelf->testbench_top__DOT____Vcellinp__u_input_mem__web));
    bufp->fullIData(oldp+78,(vlSelf->testbench_top__DOT__i),32);
    bufp->fullIData(oldp+79,(vlSelf->testbench_top__DOT__file1),32);
    bufp->fullBit(oldp+80,(vlSelf->testbench_top__DOT__clk));
    bufp->fullBit(oldp+81,(vlSelf->testbench_top__DOT__comp_enb));
    bufp->fullQData(oldp+82,(vlSelf->testbench_top__DOT__u_input_mem__DOT__data_out),64);
    bufp->fullBit(oldp+84,(vlSelf->testbench_top__DOT__busyb));
    bufp->fullBit(oldp+85,(vlSelf->testbench_top__DOT__done));
    bufp->fullQData(oldp+86,(vlSelf->testbench_top__DOT__u_res_mem__DOT__data_out),64);
}

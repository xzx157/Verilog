// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtestbench_top__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vtestbench_top::Vtestbench_top(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtestbench_top__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtestbench_top::Vtestbench_top(const char* _vcname__)
    : Vtestbench_top(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtestbench_top::~Vtestbench_top() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtestbench_top___024root___eval_debug_assertions(Vtestbench_top___024root* vlSelf);
#endif  // VL_DEBUG
void Vtestbench_top___024root___eval_static(Vtestbench_top___024root* vlSelf);
void Vtestbench_top___024root___eval_initial(Vtestbench_top___024root* vlSelf);
void Vtestbench_top___024root___eval_settle(Vtestbench_top___024root* vlSelf);
void Vtestbench_top___024root___eval(Vtestbench_top___024root* vlSelf);

void Vtestbench_top::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtestbench_top::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtestbench_top___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtestbench_top___024root___eval_static(&(vlSymsp->TOP));
        Vtestbench_top___024root___eval_initial(&(vlSymsp->TOP));
        Vtestbench_top___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtestbench_top___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtestbench_top::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vtestbench_top::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vtestbench_top::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtestbench_top___024root___eval_final(Vtestbench_top___024root* vlSelf);

VL_ATTR_COLD void Vtestbench_top::final() {
    Vtestbench_top___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtestbench_top::hierName() const { return vlSymsp->name(); }
const char* Vtestbench_top::modelName() const { return "Vtestbench_top"; }
unsigned Vtestbench_top::threads() const { return 1; }
void Vtestbench_top::prepareClone() const { contextp()->prepareClone(); }
void Vtestbench_top::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vtestbench_top::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vtestbench_top___024root__trace_decl_types(VerilatedVcd* tracep);

void Vtestbench_top___024root__trace_init_top(Vtestbench_top___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtestbench_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtestbench_top___024root*>(voidSelf);
    Vtestbench_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vtestbench_top___024root__trace_decl_types(tracep);
    Vtestbench_top___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vtestbench_top___024root__trace_register(Vtestbench_top___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vtestbench_top::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtestbench_top::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vtestbench_top___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}

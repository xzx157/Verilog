# ============================================================================
# Makefile — iverilog verification for accelerator memory comparison
#
# Targets:
#   make          - compile and run simulation (default)
#   make compile  - compile only (generates sim.vvp)
#   make run      - run compiled simulation
#   make clean    - remove generated files
#   make waves    - run and open waveform in GTKWave (if installed)
#
# Three DUTs compared:
#   (a) accelerator_array      — 2D array inferred memory
#   (b) accelerator_sram       — SRAM macro instantiated inside
#   (c) accelerator_top        — SRAM extracted to top level
# ============================================================================

# ---------------------------------------------------------------------------
# Tool configuration
# ---------------------------------------------------------------------------
IVERILOG  := iverilog
VVP       := vvp
GTKWAVE   := gtkwave

# ---------------------------------------------------------------------------
# iverilog flags
#   -g2012        : enable Verilog-2005 + some SystemVerilog subset (safe)
#   -Wall         : all warnings
#   -Wno-implicit : suppress implicit wire warnings (we use `default_nettype)
# ---------------------------------------------------------------------------
IVFLAGS   := -g2012 -Wall

# ---------------------------------------------------------------------------
# Source files (order matters for some simulators; iverilog is order-independent)
# ---------------------------------------------------------------------------
SRCS := \
    sram_model.v \
    accelerator_array.v \
    accelerator_sram.v \
    accelerator_sram_ext.v \
    accelerator_top.v \
    tb_accelerator.v

# ---------------------------------------------------------------------------
# Output files
# ---------------------------------------------------------------------------
SIM    := sim.vvp
VCD    := sim.vcd

# ============================================================================
# Default target
# ============================================================================
.PHONY: all
all: compile run

# ============================================================================
# Compile
# ============================================================================
.PHONY: compile
compile: $(SIM)

$(SIM): $(SRCS)
	$(IVERILOG) $(IVFLAGS) -o $@ $^

# ============================================================================
# Run
# ============================================================================
.PHONY: run
run: $(SIM)
	$(VVP) $(SIM)

# ============================================================================
# Run with VCD dump for waveform viewing
# ============================================================================
.PHONY: waves
waves: $(SIM)
	$(VVP) -v $(SIM) -lxt2
	@echo "VCD dumped to $(VCD)"

# ============================================================================
# Lint / syntax check only (no elaboration)
# ============================================================================
.PHONY: lint
lint:
	@for src in $(SRCS); do \
		echo "Checking $$src ..."; \
		$(IVERILOG) $(IVFLAGS) -t null -o /dev/null $$src 2>&1 || true; \
	done

# ============================================================================
# Clean
# ============================================================================
.PHONY: clean
clean:
	rm -f $(SIM) $(VCD)
	rm -f *.vcd *.lxt *.lxt2 *.fst

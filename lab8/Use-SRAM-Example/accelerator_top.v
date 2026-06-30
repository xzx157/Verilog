// ============================================================================
// Module: accelerator_top
// Purpose: Top-level wrapper for the SRAM-extracted accelerator (version c).
//          Instantiates both the sram_model (external SRAM) and the
//          accelerator_sram_ext, connecting the extracted SRAM ports between
//          them.  Presents the same clean high-level accelerator interface
//          as (a) and (b) — the SRAM wiring is internal to this wrapper.
//
//          This is the structural counterpart to accelerator_sram (version b)
//          where the SRAM was hidden inside the accelerator module itself.
//          Here the integrator has full visibility and control over the SRAM
//          instance (placement, power gating, BIST collar insertion, etc.).
// Language: Verilog HDL 2005 (IEEE 1364-2005)
// ============================================================================

`default_nettype none

module accelerator_top #(
    parameter ADDR_WIDTH = 8,   // Address width (depth = 2^ADDR_WIDTH)
    parameter DATA_WIDTH = 32   // Data word width
) (
    input  wire                    clk,            // System clock
    input  wire                    rst_n,          // Active-low reset

    // Accelerator control interface (high-level, identical to (a) and (b))
    input  wire                    start,          // Start operation
    input  wire [DATA_WIDTH-1:0]   operand,        // Operand to add
    input  wire [ADDR_WIDTH-1:0]   addr,           // Memory address
    output wire [DATA_WIDTH-1:0]   result,         // Computed result
    output wire                    done            // Operation complete
);

    // -------------------------------------------------------------------------
    // Interconnect wires between accelerator_sram_ext and SRAM
    // -------------------------------------------------------------------------
    wire                    sram_cs_n;     // Chip select
    wire                    sram_we_n;     // Write enable
    wire [ADDR_WIDTH-1:0]   sram_addr;     // Address
    wire [DATA_WIDTH-1:0]   sram_wdata;    // Write data
    wire [DATA_WIDTH-1:0]   sram_rdata;    // Read data

    // ======================================================================
    // (c) SRAM EXTRACTED — instantiated at the TOP level
    // ======================================================================
    // The SRAM lives here in the top module, NOT inside the accelerator.
    // This gives the integrator full control over the SRAM macro.
    // ======================================================================
    sram_model #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) u_sram (
        .clk    (clk),
        .rst_n  (rst_n),
        .cs_n   (sram_cs_n),
        .we_n   (sram_we_n),
        .addr   (sram_addr),
        .wdata  (sram_wdata),
        .rdata  (sram_rdata)
    );

    // -------------------------------------------------------------------------
    // Accelerator (SRAM-extracted version) — SRAM ports wired externally
    // -------------------------------------------------------------------------
    accelerator_sram_ext #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) u_accel (
        .clk        (clk),
        .rst_n      (rst_n),
        // High-level accelerator interface
        .start      (start),
        .operand    (operand),
        .addr       (addr),
        .result     (result),
        .done       (done),
        // SRAM ports — connected to the SRAM instance above
        .sram_cs_n  (sram_cs_n),
        .sram_we_n  (sram_we_n),
        .sram_addr  (sram_addr),
        .sram_wdata (sram_wdata),
        .sram_rdata (sram_rdata)
    );

endmodule

`default_nettype wire

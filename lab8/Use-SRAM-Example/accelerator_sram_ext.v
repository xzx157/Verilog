// ============================================================================
// Module: accelerator_sram_ext
// Purpose: Simple read-modify-write accelerator with the SRAM *extracted* to
//          the outside.  Unlike (a) and (b), this module has NO internal
//          memory — it exposes raw SRAM ports that the top-level wrapper
//          connects to an external SRAM macro.
//
//          The high-level accelerator interface (start/operand/addr/result/done)
//          is identical to (a) and (b).  The SRAM ports are an ADDITIONAL
//          interface that gives the integrator full control over the memory
//          macro (placement, power gating, BIST muxing, sharing, etc.).
//
// Approach (c): SRAM extracted — maximum flexibility, but more ports at top.
// Language: Verilog HDL 2005 (IEEE 1364-2005)
// ============================================================================

`default_nettype none

module accelerator_sram_ext #(
    parameter ADDR_WIDTH = 8,   // Address width (depth = 2^ADDR_WIDTH)
    parameter DATA_WIDTH = 32   // Data word width
) (
    input  wire                    clk,            // System clock
    input  wire                    rst_n,          // Active-low reset

    // Accelerator control interface (high-level, same as (a) and (b))
    input  wire                    start,          // Start operation
    input  wire [DATA_WIDTH-1:0]   operand,        // Operand to add
    input  wire [ADDR_WIDTH-1:0]   addr,           // Memory address
    output reg  [DATA_WIDTH-1:0]   result,         // Computed result
    output reg                     done,           // Operation complete

    // ======================================================================
    // (c) SRAM INTERFACE PORTS — EXTRACTED TO TOP LEVEL
    // ======================================================================
    // These ports are the key difference from versions (a) and (b).
    // The SRAM lives OUTSIDE this module; these ports are wired to the
    // SRAM macro in the top-level wrapper (accelerator_top).
    // ======================================================================
    output reg                     sram_cs_n,      // SRAM chip select (active low)
    output reg                     sram_we_n,      // SRAM write enable (active low)
    output reg  [ADDR_WIDTH-1:0]   sram_addr,      // SRAM address
    output reg  [DATA_WIDTH-1:0]   sram_wdata,     // SRAM write data
    input  wire [DATA_WIDTH-1:0]   sram_rdata      // SRAM read data
);

    // -------------------------------------------------------------------------
    // FSM states (one-hot)
    // -------------------------------------------------------------------------
    localparam [1:0] ST_IDLE  = 2'd0;
    localparam [1:0] ST_READ  = 2'd1;
    localparam [1:0] ST_WRITE = 2'd2;
    localparam [1:0] ST_DONE  = 2'd3;

    // -------------------------------------------------------------------------
    // Internal signals
    // -------------------------------------------------------------------------
    reg [1:0]            state;        // Current FSM state
    reg [1:0]            state_next;   // Next FSM state
    reg [DATA_WIDTH-1:0] sum;          // Combinational: sram_rdata + operand
    reg                  done_next;    // Next state for done
    reg [DATA_WIDTH-1:0] result_next;  // Next state for result

    // -------------------------------------------------------------------------
    // FSM sequential logic
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
        end
        else begin
            state <= state_next;
        end
    end

    // -------------------------------------------------------------------------
    // FSM combinational next-state logic
    // -------------------------------------------------------------------------
    always @* begin
        state_next = state;
        case (state)
            ST_IDLE: begin
                if (start) begin
                    state_next = ST_READ;
                end
            end
            ST_READ: begin
                state_next = ST_WRITE;
            end
            ST_WRITE: begin
                state_next = ST_DONE;
            end
            ST_DONE: begin
                if (!start) begin
                    state_next = ST_IDLE;
                end
            end
            default: begin
                state_next = ST_IDLE;
            end
        endcase
    end

    // -------------------------------------------------------------------------
    // SRAM control — drives the EXTRACTED SRAM ports based on FSM state
    // -------------------------------------------------------------------------
    always @* begin
        // SRAM is always selected
        sram_cs_n = 1'b0;

        // Default: read mode
        sram_we_n  = 1'b1;
        sram_addr  = addr;
        sram_wdata = {DATA_WIDTH{1'b0}};

        if (state == ST_WRITE) begin
            // Write mode: write sum back to SRAM
            sram_we_n  = 1'b0;
            sram_addr  = addr;
            sram_wdata = sum;
        end
    end

    // -------------------------------------------------------------------------
    // Combinational sum — uses the external SRAM read-data port
    // -------------------------------------------------------------------------
    always @* begin
        sum = sram_rdata + operand;
    end

    // -------------------------------------------------------------------------
    // Output register (result only — done is combinational)
    // -------------------------------------------------------------------------
    always @* begin
        result_next = result;

        if (state == ST_WRITE) begin
            result_next = sum;
        end
        done_next   = 1'b0;

        if (state == ST_WRITE) begin
            result_next = sum;
        end
        if (state == ST_DONE) begin
            done_next = 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {DATA_WIDTH{1'b0}};
            done   <= 1'b0;
        end
        else begin
            result <= result_next;
            done   <= done_next;
        end
    end

endmodule

`default_nettype wire

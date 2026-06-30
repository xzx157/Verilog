// ============================================================================
// Module: accelerator_sram
// Purpose: Simple read-modify-write accelerator that instantiates an SRAM macro
//          *inside* the module.  Reads a value from SRAM at `addr`, adds
//          `operand`, writes the result back, and asserts `done`.
//
// Approach (b): SRAM instance inside — encapsulates the SRAM; the accelerator
//               presents a clean high-level interface identical to (a).
//               The SRAM is invisible to the integrator.
// Language: Verilog HDL 2005 (IEEE 1364-2005)
// ============================================================================

`default_nettype none

module accelerator_sram #(
    parameter ADDR_WIDTH = 8,   // Address width (depth = 2^ADDR_WIDTH)
    parameter DATA_WIDTH = 32   // Data word width
) (
    input  wire                    clk,            // System clock
    input  wire                    rst_n,          // Active-low reset

    // Accelerator control interface (high-level — no SRAM ports)
    input  wire                    start,          // Start operation
    input  wire [DATA_WIDTH-1:0]   operand,        // Operand to add
    input  wire [ADDR_WIDTH-1:0]   addr,           // Memory address
    output reg  [DATA_WIDTH-1:0]   result,         // Computed result
    output reg                     done            // Operation complete
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
    wire [DATA_WIDTH-1:0] sram_rdata;  // SRAM read data
    reg [DATA_WIDTH-1:0] sum;          // Combinational: sram_rdata + operand
    reg                  sram_cs_n;    // SRAM chip select (active low)
    reg                  sram_we_n;    // SRAM write enable (active low)
    reg [ADDR_WIDTH-1:0] sram_addr;    // SRAM address
    reg [DATA_WIDTH-1:0] sram_wdata;   // SRAM write data
    reg                  done_next;    // Next state for done
    reg [DATA_WIDTH-1:0] result_next;  // Next state for result

    // ======================================================================
    // (b) SRAM INSTANCE INSIDE THE DESIGN
    // ======================================================================
    // The SRAM lives inside this module as a child instance.
    // All SRAM control signals are internal — never visible to the outside.
    // This is the key structural difference from version (c).
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
    // SRAM control — drive based on FSM state
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
    // Combinational sum
    // -------------------------------------------------------------------------
    always @* begin
        sum = sram_rdata + operand;
    end

    // -------------------------------------------------------------------------
    // Output registers (result, done)
    // -------------------------------------------------------------------------
    always @* begin
        result_next = result;
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

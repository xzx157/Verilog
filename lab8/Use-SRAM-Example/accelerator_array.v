// ============================================================================
// Module: accelerator_array
// Purpose: Simple read-modify-write accelerator using a 2D unpacked array as
//          internal memory.  Reads a value from memory at `addr`, adds
//          `operand`, writes the result back, and asserts `done`.
//
// Approach (a): 2D array memory — simplest, most portable, synthesis infers RAM.
//               The accelerator has a clean high-level interface; SRAM details
//               are invisible to the integrator.
// Language: Verilog HDL 2005 (IEEE 1364-2005)
// ============================================================================

`default_nettype none

module accelerator_array #(
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
    // Local parameters
    // -------------------------------------------------------------------------
    localparam DEPTH = (1 << ADDR_WIDTH);  // Total memory depth

    // -------------------------------------------------------------------------
    // FSM states (one-hot)
    // -------------------------------------------------------------------------
    localparam [1:0] ST_IDLE  = 2'd0;
    localparam [1:0] ST_READ  = 2'd1;
    localparam [1:0] ST_WRITE = 2'd2;
    localparam [1:0] ST_DONE  = 2'd3;

    // ======================================================================
    // (a) 2D ARRAY AS MEMORY
    // ======================================================================
    // synthesis attribute ram_style of mem is "block"
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];  // Internal 2D memory array

    // -------------------------------------------------------------------------
    // Internal signals
    // -------------------------------------------------------------------------
    reg [1:0]            state;        // Current FSM state
    reg [1:0]            state_next;   // Next FSM state
    reg [DATA_WIDTH-1:0] rd_data_reg;  // Registered read data from memory
    reg [DATA_WIDTH-1:0] sum;          // Combinational: rd_data_reg + operand
    reg                  wr_en_int;    // Internal write-enable for memory
    reg                  done_next;    // Next state for done
    reg [DATA_WIDTH-1:0] result_next;  // Next state for result
    integer              init_idx;     // Loop index for memory init on reset

    // -------------------------------------------------------------------------
    // Memory initialization — reset all entries to 0 (simulation only;
    // synthesis tools typically ignore memory reset for large arrays)
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (init_idx = 0; init_idx < DEPTH; init_idx = init_idx + 1) begin
                mem[init_idx] <= {DATA_WIDTH{1'b0}};
            end
        end
    end

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
    // Memory read — registered read from 2D array (1-cycle latency)
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        rd_data_reg <= mem[addr];
    end

    // -------------------------------------------------------------------------
    // Combinational sum
    // -------------------------------------------------------------------------
    always @* begin
        sum = rd_data_reg + operand;
    end

    // -------------------------------------------------------------------------
    // Memory write — write during WRITE state
    // -------------------------------------------------------------------------
    always @* begin
        wr_en_int = (state == ST_WRITE) ? 1'b1 : 1'b0;
    end

    always @(posedge clk) begin
        if (wr_en_int) begin
            mem[addr] <= sum;
        end
    end

    // -------------------------------------------------------------------------
    // Output registers (result, done)
    // -------------------------------------------------------------------------
    always @* begin
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

// ============================================================================
// Module: sram_model
// Purpose: Behavioral model of a single-port synchronous SRAM macro.
//          Represents a hard IP block that would be replaced by a vendor SRAM
//          generator (e.g., OpenRAM, Arm Artisan, foundry compiler).
//
// Language: Verilog HDL 2005 (IEEE 1364-2005)
// ============================================================================

`default_nettype none

module sram_model #(
    parameter ADDR_WIDTH = 8,   // Address width (depth = 2^ADDR_WIDTH)
    parameter DATA_WIDTH = 32   // Data word width
) (
    input  wire                    clk,        // System clock
    input  wire                    rst_n,      // Active-low reset (async)
    input  wire                    cs_n,       // Chip select (active low)
    input  wire                    we_n,       // Write enable (active low)
    input  wire [ADDR_WIDTH-1:0]   addr,       // Read/write address
    input  wire [DATA_WIDTH-1:0]   wdata,      // Write data
    output reg  [DATA_WIDTH-1:0]   rdata       // Read data
);

    // -------------------------------------------------------------------------
    // Local parameters
    // -------------------------------------------------------------------------
    localparam DEPTH = (1 << ADDR_WIDTH);  // Total memory depth

    // -------------------------------------------------------------------------
    // Memory array
    // -------------------------------------------------------------------------
    // synthesis attribute ram_style of mem is "block"
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];  // SRAM storage array
    integer              init_idx;          // Loop index for memory init on reset

    // -------------------------------------------------------------------------
    // Memory initialization — reset all entries to 0 (simulation only)
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (init_idx = 0; init_idx < DEPTH; init_idx = init_idx + 1) begin
                mem[init_idx] <= {DATA_WIDTH{1'b0}};
            end
        end
    end

    // -------------------------------------------------------------------------
    // Write logic — synchronous write with chip-select and write-enable gating
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // SRAM content not reset in hardware — included here for simulation
            // In real silicon, SRAM powers up to unknown (X) values.
        end
        else if (!cs_n && !we_n) begin
            mem[addr] <= wdata;
        end
    end

    // -------------------------------------------------------------------------
    // Read logic — synchronous read (registered output models SRAM output flop)
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdata <= {DATA_WIDTH{1'b0}};
        end
        else if (!cs_n && we_n) begin
            rdata <= mem[addr];
        end
    end

endmodule

`default_nettype wire

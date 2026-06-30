`timescale 1ns/1ns
`default_nettype none

module accelerator_logic_top #(
    parameter ROWS = 12,
    parameter COLS = 16,
    parameter ACC_BITS = 32
) (
    input  wire                       clk,
    input  wire                       rst_n,
    input  wire                       clear_acc,
    input  wire                       pulse_en,
    input  wire signed [15:0]         a_sram_rdata [0:ROWS-1],
    input  wire signed [15:0]         b_sram_rdata [0:COLS-1],
    output wire signed [ACC_BITS-1:0] c_out [0:ROWS-1][0:COLS-1]
);

    wire signed [7:0] a_core_in [0:ROWS-1];
    wire signed [7:0] b_core_in [0:COLS-1];

    genvar idx;

    generate
        for (idx = 0; idx < ROWS; idx = idx + 1) begin : gen_a_core_in
            assign a_core_in[idx] = $signed(a_sram_rdata[idx][7:0]);
        end

        for (idx = 0; idx < COLS; idx = idx + 1) begin : gen_b_core_in
            assign b_core_in[idx] = $signed(b_sram_rdata[idx][7:0]);
        end
    endgenerate

    accelerator_sram_ext #(
        .ROWS(ROWS),
        .COLS(COLS),
        .ACC_BITS(ACC_BITS)
    ) u_compute_core (
        .clk(clk),
        .rst_n(rst_n),
        .clear_acc(clear_acc),
        .pulse_en(pulse_en),
        .a_row_in(a_core_in),
        .b_col_in(b_core_in),
        .c_out(c_out)
    );

endmodule

`default_nettype wire

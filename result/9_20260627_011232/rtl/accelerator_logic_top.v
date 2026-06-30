`timescale 1ns/1ns
`default_nettype none

module accelerator_logic_top #(
    parameter ROWS = 1,
    parameter COLS = 32,
    parameter ACC_BITS = 25
) (
    input  wire                       clk,
    input  wire                       rst_n,
    input  wire                       clear_acc,
    input  wire                       pulse_en,
    input  wire        [7:0]          a_sram_rdata,
    input  wire        [127:0]        b_sram_rdata0,
    input  wire        [127:0]        b_sram_rdata1,
    output wire signed [ACC_BITS-1:0] c_out [0:ROWS-1][0:COLS-1]
);

    wire signed [ROWS*8-1:0] a_core_in;
    wire signed [COLS*8-1:0] b_core_in;

    genvar idx;

    generate
        for (idx = 0; idx < ROWS; idx = idx + 1) begin : gen_a_core_in
            assign a_core_in[(ROWS-1-idx)*8 +: 8] = $signed(a_sram_rdata);
        end

        for (idx = 0; idx < COLS; idx = idx + 1) begin : gen_b_core_in
            if (idx < 16) begin : gen_b_bank0
                assign b_core_in[(COLS-1-idx)*8 +: 8] = $signed(b_sram_rdata0[(15-idx)*8 +: 8]);
            end else begin : gen_b_bank1
                assign b_core_in[(COLS-1-idx)*8 +: 8] = $signed(b_sram_rdata1[(31-idx)*8 +: 8]);
            end
        end
    endgenerate

    accelerator_sram_ext u_compute_core (
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

`timescale 1ns/1ns
`default_nettype none

module pe_mac #(
    parameter ACC_BITS = 25
) (
    input  wire                       clk,
    input  wire                       rst_n,
    input  wire                       clear_acc,
    input  wire                       pulse_en,
    input  wire signed [7:0]          a_in,
    input  wire signed [7:0]          b_in,
    output reg  signed [ACC_BITS-1:0] acc_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_out <= {ACC_BITS{1'b0}};
        end else if (clear_acc) begin
            acc_out <= {ACC_BITS{1'b0}};
        end else if (pulse_en) begin
            acc_out <= acc_out + ($signed(a_in) * $signed(b_in));
        end
    end

endmodule

module accelerator_sram_ext #(
    parameter ROWS = 4,
    parameter COLS = 12,
    parameter ACC_BITS = 25
) (
    input  wire                       clk,
    input  wire                       rst_n,
    input  wire                       clear_acc,
    input  wire                       pulse_en,
    input  wire signed [7:0]          a_row_in [0:ROWS-1],
    input  wire signed [7:0]          b_col_in [0:COLS-1],
    output wire signed [ACC_BITS-1:0] c_out [0:ROWS-1][0:COLS-1]
);

    genvar r;
    genvar c;

    generate
        for (r = 0; r < ROWS; r = r + 1) begin : gen_rows
            for (c = 0; c < COLS; c = c + 1) begin : gen_cols
                pe_mac #(
                    .ACC_BITS(ACC_BITS)
                ) u_pe_mac (
                    .clk(clk),
                    .rst_n(rst_n),
                    .clear_acc(clear_acc),
                    .pulse_en(pulse_en),
                    .a_in(a_row_in[r]),
                    .b_in(b_col_in[c]),
                    .acc_out(c_out[r][c])
                );
            end
        end
    endgenerate

endmodule

`default_nettype wire

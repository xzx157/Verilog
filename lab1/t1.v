module parity (
    input [15:0] in,
    output even_bit
);

    assign even_bit = ^in;

endmodule
`timescale 1ns/1ns
`include "t1.v"

module t1_tb;

reg [15:0] data_in;
wire even;

parity dut0(
    .in(data_in),
    .even_bit(even)
);

initial begin
    $dumpfile("wave_t1.vcd");
    $dumpvars(0, t1_tb);
end

initial begin
    $display("Time\tData_In\t\tEven");
    $monitor("%0dns\t%b\t%b", $time, data_in, even);

    data_in = 16'b0;
    #10;

    data_in = 16'b0000_0000_0000_0001;
    #10;

    data_in = 16'b0000_0000_0000_0011;
    #10;

    data_in = 16'hFFFF;
    #10;

    data_in = 16'hA5A5;
    #10;

    $finish;
end

endmodule
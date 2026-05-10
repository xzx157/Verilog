`timescale 1ns/1ns
`include "t2.v"

module t2_tb;

reg rst, clk;
wire [15:0] gray_out;

gray dut0(
    .clk(clk),
    .rst(rst),
    .gray_out(gray_out)
);

initial begin
    $dumpfile("wave_t2.vcd");
    $dumpvars(0);
    $monitor("time=%4t,clk=%1b, rst=%1b, gray_out=%4b",$time,clk,rst,gray_out);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 0;
    #1 rst = 1;
    #10 rst = 0;
    #60 $finish;
end

endmodule
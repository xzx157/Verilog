`timescale 1ns/1ns
`include "t1.v"

module t1_tb;

reg rst, clk, up_down;
wire [3:0] count;

counter dut0(
    .clk(clk),
    .rst(rst),
    .up_down(up_down),
    .count(count)
);

initial begin
    $dumpfile("wave_t1.vcd");
    $dumpvars(0);
    $monitor("time=%4t,clk=%1b, rst=%1b, count=%4b",$time,clk,rst,count);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 0;
    up_down = 0;
    #1 rst = 1;
    #10 rst = 0;
    #40 up_down = 1;
    #31 rst = 1;
    #10 rst = 0;
    #20 $finish;
end

endmodule
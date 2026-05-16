`timescale 1ns/1ns
`include "t1.v"

module t1_tb;

reg rstb, clk, data_in;
wire data_out;

PasscodeDetector dut0(
    .clk(clk),
    .data_in(data_in),
    .rstb(rstb),
    .data_out(data_out)
);

initial begin
    $dumpfile("wave_t1.vcd");
    $dumpvars(0);
    $monitor("time=%4t,clk=%1b, rstb=%1b, data_in=%1b, data_out=%1b",$time,clk,rstb,data_in,data_out);
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rstb = 1;
    data_in = 0;
    #1 rstb = 0;
    #10 rstb = 1;
    #10 data_in = 1;
    #10 data_in = 0;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0;    
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 1;
    #10 data_in = 0; 
    #10 data_in = 0; 
    #10 $finish;
end

endmodule
`timescale 1ms/1ms
`include "t2.v"

module t2_tb;

reg reset, clk, sa, sb;
wire [1:0] la, lb;

verilog_fsm dut0(
    .clk(clk),
    .reset(reset),
    .sa(sa),
    .sb(sb),
    .la(la),
    .lb(lb)
);

initial begin
    $dumpfile("wave_t2.vcd");
    $dumpvars(0);
    $monitor("time=%4t,clk=%1b, reset=%1b, sa=%1b, sb=%1b, la=%2b, lb=%2b",$time,clk,reset,sa,sb,la,lb);
end

initial begin
    clk = 0;
    forever #2500 clk = ~clk;
end

initial begin
    reset = 0;
    sa = 0;
    sb = 0;
    #500 reset = 1;      
    #5000 reset = 0;     
    #5000 sa = 1;              
    #5000 sb = 1;                
    #60000 sa = 0;
    #10000 sb = 0;
    #10000 $finish;
end

endmodule
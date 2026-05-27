`timescale 1ns/1ns
`include "uart.v"
`include "test.v"
module test_top;

reg sys_clk = 0;
reg rstb = 0;
reg uart_rx = 0;
wire uart_tx;

always #1 sys_clk = ~sys_clk;

initial begin
	#2 rstb = 1;
	#100000 $finish;
end

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,test_top);
end

test1 u1(
.sys_clk(sys_clk),
.rstb(rstb),
.uart_tx(uart_tx)
);

endmodule
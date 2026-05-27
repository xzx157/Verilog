`timescale 1ns/1ns
`include "FIFO.v"
`include "RAM_sync.v"
module fifo_tb;
	reg clk;
	reg rstb;
	reg rd;
	reg wr;
	reg [15:0] data_in;
	wire [15:0] data_out;
	wire empty;
	wire full;

	fifo dut (
		.clk(clk),
		.rstb(rstb),
		.rd(rd),
		.wr(wr),
		.data_in(data_in),
		.data_out(data_out),
		.empty(empty),
		.full(full)
	);

	initial begin
		$dumpfile("wave_fifo.vcd");
		$dumpvars(0);
	end

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	integer i;
	initial begin
		rstb = 1'b0;
		rd = 1'b0;
		wr = 1'b0;
		data_in = 16'h0000;

		repeat (2) @(posedge clk);
		rstb = 1'b1;

		for (i = 0; i < 16; i = i + 1) begin
			@(negedge clk);
			wr = 1'b1;
			rd = 1'b0;
			data_in = i[15:0];
		end
		@(negedge clk);
		wr = 1'b0;

		for (i = 0; i < 4; i = i + 1) begin
			@(negedge clk);
			rd = 1'b1;
			wr = 1'b0;
		end
		@(negedge clk);
		rd = 1'b0;

		for (i = 0; i < 15; i = i + 1) begin
			@(negedge clk);
			rd = 1'b1;
		end
		@(negedge clk);
		rd = 1'b0;

		#20;
		$finish;
	end
endmodule

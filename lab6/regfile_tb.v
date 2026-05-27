`timescale 1ns/1ps
`include "regfile.v"
module regfile_tb;
  localparam DataWidth = 32;
  localparam NumRegs =32;
  localparam IndexWidth = $clog2(NumRegs);

  reg clk;
  reg writeEn;
  reg [IndexWidth-1:0] writeAddr;
  reg [DataWidth-1:0] writeData;
  reg [IndexWidth-1:0] readAddr1;
  reg [IndexWidth-1:0] readAddr2;
  wire [DataWidth-1:0] readData1;
  wire [DataWidth-1:0] readData2;

  RegisterFile #(
    .DataWidth(DataWidth),
    .NumRegs(NumRegs),
    .IndexWidth(IndexWidth)
  ) dut (
    .clk(clk),
    .writeEn(writeEn),
    .writeAddr(writeAddr),
    .writeData(writeData),
    .readAddr1(readAddr1),
    .readAddr2(readAddr2),
    .readData1(readData1),
    .readData2(readData2)
  );

  initial begin
    $dumpfile("wave_regfile.vcd");
    $dumpvars(0);
  end

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    writeEn = 1'b0;
    writeAddr = '0;
    writeData = '0;
    readAddr1 = '0;
    readAddr2 = '0;

    @(negedge clk);
    writeEn = 1'b1;
    writeAddr = 0;
    writeData = 32'h11111111;
    @(negedge clk);
    writeEn = 1'b0;

    @(negedge clk);
    writeEn = 1'b1;
    writeAddr = 1;
    writeData = 32'h22222222;
    @(negedge clk);
    writeEn = 1'b0;

    @(negedge clk);
    writeEn = 1'b1;
    writeAddr = 3;
    writeData = 32'h000000A5;
    @(negedge clk);
    writeEn = 1'b0;

    @(negedge clk);
    writeEn = 1'b1;
    writeAddr = 5;
    writeData = 32'h12345678;
    @(negedge clk);
    writeEn = 1'b0;

    @(negedge clk);
    readAddr1 = 3;
    readAddr2 = 5;
    #2;
    readAddr1 = 5;
    #2;
    readAddr2 = 3;


    @(negedge clk);
    writeEn = 1'b1;
    writeAddr = 3;
    writeData = 32'h0F0F0F0F;
    @(negedge clk);
    writeEn = 1'b0;
    @(negedge clk);
    readAddr1 = 3;
    readAddr2 = 5;

    #10;
    $finish;
  end
endmodule

`timescale 1ns/1ns
`include "RAM_async.v"
`include "RAM_sync.v"
module tb;

reg clk;
reg [7:0] addr;
reg [15:0] d;
reg cs;
reg web;
reg oe;
wire [15:0] q_ar;
wire [15:0] q_sr;
integer i;

initial begin
    $dumpfile("wave_RAM.vcd");
    $dumpvars(0);
    $monitor("time=%4t, clk=%1b, web=%1b, d=%2h, q_ar=%2h, q_sr=%2h",$time,clk,web,d,q_ar,q_sr);
end

initial
begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial
begin
    cs = 1;
    oe = 1;
    // test write
    for(i=0;i<(1<<4);i=i+1) begin
        #2 web=0;
        addr = i;
        d = i;
    end
    // test read
    for(i=0;i<(1<<4);i=i+1) begin
        #2 web=1;
        addr = i;
        d = $random;
    end

    #10 $finish;
end

// Async read RAM
ram_ar #(.DATA_WIDTH(16), .ADDR_WIDTH(8)) u0 (
    .clk( clk )
    ,.address ( addr )
    ,.d  ( d )
    ,.q ( q_ar )
    ,.cs ( cs )
    ,.web ( web )
    ,.oe ( oe )
); 

// Sync read RAM
ram_sr #(.DATA_WIDTH(16), .ADDR_WIDTH(8)) u1 (
    .clk( clk )
    ,.address ( addr )
    ,.d  ( d )
    ,.q ( q_sr )
    ,.cs ( cs )
    ,.web ( web )
    ,.oe ( oe )
);

endmodule
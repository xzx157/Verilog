`timescale 1ns/1ns
`include "main.v"

module decoder_testbench;

reg [1:0] in;
wire [3:0] out1,out2,out3;

decoder2_4_1 dut0(
.decode_in      (in)
, .decode_out   (out1)
);

decoder2_4_2 dut1(
.decode_in      (in)
, .decode_out   (out2)
);

decoder2_4_3 dut2(
.decode_in      (in)
, .decode_out   (out3)
);

integer i; //integer is a 32b unsigned integer

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0);
end

initial begin
    $monitor("time=%4d, in=%4b, out0=%04b, out1=%04b, out2=%04b", $time, in, out1, out2, out3);
    // $monitor为Verilog系统自带函数, 格式像c++的printf一样，意为“每当要print的变量发生变化即打印”，同理还有$display(仅在当前仿真运行时间打印一样结果)
    for(i=0; i<8; i=i+1) begin
        #10 in = i; 
    end
end

endmodule
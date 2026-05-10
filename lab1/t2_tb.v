`timescale 1ns / 1ns
`include "t2.v"
module tb_thermometer_decoder;

    reg  [1022:0] thermo_in;
    wire [9:0]    bin_out;
    wire          error;

    // 实例化
    thermometer_decoder uut (
        .thermo_in(thermo_in),
        .bin_out(bin_out),
        .error(error)
    );
    initial begin
        $dumpfile("wave_t2.vcd");
        $dumpvars(0, tb_thermometer_decoder);
    end
    initial begin
        thermo_in = 0;
        #10;

        thermo_in = 1023'h7; 
        #10 $display("In: 3 bits, Out: %d, Error: %b", bin_out, error);

        thermo_in = (1'b1 << 10) - 1; 
        #10 $display("In: 10 bits, Out: %d, Error: %b", bin_out, error);

        thermo_in = 1023'b1000011; 
        #10 $display("In: Bubble, Out: %d, Error: %b", bin_out, error);

        thermo_in = ~1023'b0;
        #10 $display("In: Max, Out: %d, Error: %b", bin_out, error);

        $finish;
    end

endmodule
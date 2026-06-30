`timescale 1ns / 1ps

// Define clock period as macro for easy modification
`define CLK_PERIOD 2

module tb_ProgramCounter();

    // Input signals declaration
    reg clk;
    reg reset;
    reg [15:0] dataIn;
    reg writeEnable; 
    reg writeAdd; 
    reg countEnable;

    // Output signal declaration
    wire [15:0] dataOut;

    // Instantiate the module under test
    ProgramCounter uut (
        .clk(clk),
        .reset(reset),
        .dataIn(dataIn),
        .dataOut(dataOut),
        .writeEnable(writeEnable),
        .writeAdd(writeAdd),
        .countEnable(countEnable)
    );

    initial begin
    	$dumpfile("wave.vcd");
    	$dumpvars(0);
    end

    // Generate clock signal - using defined period
    initial begin
        clk = 0;
        forever #(`CLK_PERIOD/2) clk = ~clk;  // Toggle every half period to achieve full period
    end

    // Test sequence
    initial begin
        $display("Starting ProgramCounter module test...");
        $monitor("Time=%0t, clk=%b, reset=%b, dataIn=%h, writeEnable=%b, writeAdd=%b, countEnable=%b, dataOut=%h", 
                 $time, clk, reset, dataIn, writeEnable, writeAdd, countEnable, dataOut);

        // Initialize all input signals
        reset = 1'b1;
        dataIn = 16'h0000;
        writeEnable = 1'b0;
        writeAdd = 1'b0;
        countEnable = 1'b0;

        // Test reset functionality
        #(`CLK_PERIOD*2);  // Wait for 2 clock periods
        $display("After reset: dataOut = %h", dataOut);
        
        // Release reset
        reset = 1'b0;
        #(`CLK_PERIOD);

        // Test 1: Write mode - Set PC value to 0x1000
        $display("\nTest 1: Write mode - Set PC value");
        writeEnable = 1'b1;
        writeAdd = 1'b0;  // Directly set PC value
        dataIn = 16'h1000;
        #(`CLK_PERIOD);
        writeEnable = 1'b0;
        $display("After writing 0x1000: dataOut = %h", dataOut);
        #(`CLK_PERIOD);

        // Test 2: Write mode - Add to PC value
        $display("\nTest 2: Write mode - Add to PC value");
        writeEnable = 1'b1;
        writeAdd = 1'b1;  // Add to PC value
        dataIn = 16'h0004;
        #(`CLK_PERIOD);
        writeEnable = 1'b0;
        $display("After adding 0x0004: dataOut = %h", dataOut);
        #(`CLK_PERIOD);

        // Test 3: Count enable mode - Auto increment
        $display("\nTest 3: Count enable mode - Auto increment");
        countEnable = 1'b1;
        #(`CLK_PERIOD*5);  // Run several clock cycles to observe auto increment
        $display("During auto increment: dataOut = %h", dataOut);
        #(`CLK_PERIOD);
        countEnable = 1'b0;
        #(`CLK_PERIOD);

        // Test 4: Stop mode - Hold unchanged
        $display("\nTest 4: Stop mode - Hold unchanged");
        #(`CLK_PERIOD*3);
        $display("In stop mode: dataOut = %h", dataOut);

        // Test 5: Reset test again
        $display("\nTest 5: Reset again");
        reset = 1'b1;
        #(`CLK_PERIOD);
        $display("After reset again: dataOut = %h", dataOut);
        reset = 1'b0;
        #(`CLK_PERIOD);

        // Test 6: Comprehensive test - Set initial value then auto increment
        $display("\nTest 6: Comprehensive test - Set value then auto increment");
        writeEnable = 1'b1;
        writeAdd = 1'b0;
        dataIn = 16'h2000;
        #(`CLK_PERIOD);
        writeEnable = 1'b0;
        #(`CLK_PERIOD);
        
        countEnable = 1'b1;
        #(`CLK_PERIOD*8);  // Observe multiple increments
        countEnable = 1'b0;
        #(`CLK_PERIOD);

        $display("\nTest completed!");
        $finish;
    end

endmodule

module test;

reg [3:0] counter;
reg rst;
reg clk;
wire [1:0] led;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    rst = 0;
    #10 rst = 1;
    #10 counter = 4'd8;
    #10 rst = 0;
    #100 $finish;
end

initial begin
    $monitor(counter);
end

always @(posedge clk) begin
    counter <= counter + 1 + led;
end

assign led = counter[1]+1;

initial begin
    $dumpfile("wave_t4.vcd"); 
    $dumpvars(0);       
end

endmodule
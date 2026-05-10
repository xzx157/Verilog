module test;

reg [7:0] counter;
reg rst;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    rst = 0;
    #11 rst = 1;
    #10 rst = 0;
    #100 $finish;
end

initial begin
    $monitor("time=%0t counter=%0d", $time, counter);
end


always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
    end 
    else begin
    counter <= counter + 1;
    end
end

initial begin
    $dumpfile("wave_t2.vcd"); 
    $dumpvars(0);       
end

endmodule
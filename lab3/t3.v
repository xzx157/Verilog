module test1;

reg en;
reg [7:0] a1,b1,i1;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    a1 = 0;
    b1 = 0;
    i1 = 0;
    en = 1;
    #100 $finish;
end

initial begin
    $monitor("a=%d, b=%d, i=%d", a1, b1, i1);
end

always @(posedge clk) begin
if(i1<=8'd16) begin
    i1 = i1+1;
    b1 = a1+1;
    a1 = i1;
end
end

endmodule

module test2;

reg en;
reg [7:0] a2,b2,i2;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    a2 = 0;
    b2 = 0;
    i2 = 0;
    en = 1;
    #100 $finish;
end

initial begin
    $monitor("a=%d, b=%d, i=%d", a2, b2, i2);
    
end

always @(posedge clk) begin
if(i2<=8'd16) begin
    i2 = i2+1;
    a2 = i2;
    b2 = a2+1;
end
end

initial begin
    $dumpfile("wave_t3.vcd"); 
    $dumpvars(0);       
end

endmodule


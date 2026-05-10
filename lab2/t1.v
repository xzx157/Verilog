module counter (
    input clk,
    input rst,
    input up_down,
    output reg [3:0] count
);

always @(posedge clk ) begin
    if (rst & ~up_down) begin
        count <= 4'b0000;
    end 
    else if (rst & up_down) begin
        count <= 4'b1111;
    end
    else if (up_down) begin
        count <= count - 1;
    end 
    else begin
        count <= count + 1;
    end
end
endmodule
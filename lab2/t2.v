module gray(
    input rst,clk,
    output wire [15:0] gray_out
);
reg[15:0] counter;
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
    end 
    else begin
        counter <= counter + 1;
    end
end

assign gray_out = counter ^ (counter >> 1);

endmodule
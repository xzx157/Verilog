module thermometer_decoder (
    input  wire [1022:0] thermo_in,  // 1023位温度计码输入
    output reg  [9:0]    bin_out,    // 10位二进制输出
    output reg           error       // 报错
);

    integer i;
    reg [9:0] count;

    always @(*) begin
        count = 10'd0;
        error = 1'b0;
        
        // 1. 统计1的个数
        for (i = 0; i < 1023; i = i + 1) begin
            if (thermo_in[i]) begin
                count = count + 1'b1;
            end
        end
        
        // 2. 校验（是否存在“01”）
        for (i = 1; i < 1023; i = i + 1) begin
            if (thermo_in[i] && !thermo_in[i-1]) begin
                error = 1'b1;
            end
        end
        
        bin_out = count;
    end

endmodule
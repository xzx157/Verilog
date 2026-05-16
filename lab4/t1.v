module PasscodeDetector(
    input clk, data_in, rstb,
    output reg data_out
);

reg [1:0] state;
parameter STAT_IDLE = 0,
            STATE_R1 = 1,
            STATE_R2 = 2,
            STATE_R3 = 3;

always @(state) begin
    if(state==STATE_R3)
        data_out <= 1;
    else
        data_out <= 0;
end

always @(posedge clk or negedge rstb) begin
    if(!rstb)
        state <= STAT_IDLE;
    else
        case(state)
            STAT_IDLE:
                if(data_in==1) //或者写成if(data_in)
                    state <= STATE_R1;
            STATE_R1:
                if(data_in==1)
                    state <= STATE_R2;
                else
                    state <= STAT_IDLE;
            STATE_R2:
                if(data_in==0)//或者写成if(~data_in)或者if(!data_in)
                    state <= STATE_R3;
                else
                    state <= STATE_R2;
            default://STATE_R3,为了可综合必须要有default
                if(data_in==1)
                        state <= STATE_R1;
                    else
                        state <= STAT_IDLE;
        endcase
end

endmodule
module verilog_fsm (clk, reset, sa, sb, la,lb);
    input  clk, reset;
    input sa,sb;
    output reg [1:0] la,lb;
    parameter state_0 = 2'b00;
    parameter state_1 = 2'b01;
    parameter state_2 = 2'b10;
    parameter state_3 = 2'b11;
    localparam GREEN  = 2'b00;
    localparam YELLOW = 2'b01;
    localparam RED    = 2'b10;
    reg [1:0] state, next_state;
    reg [3:0] counter;
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            state <= state_0;
            counter <= 4'b0000;
        end
        else begin
            state <= next_state;
            if ((state == state_0 || state == state_2) && (sa && sb)) begin
                if (counter < 6)
                    counter <= counter + 1'b1;
            end 
            else begin
                counter <= 4'b0000;
            end
        end
    end
    always @ (*)
    begin
        case (state)
            state_0: begin
                if ((sa && ~sb) || (sa && sb && counter >= 5))begin
                    next_state=state_1;
                end
                else begin
                    next_state=state_0;
                end
            end
            state_1: begin
                next_state = state_2;
            end    
            state_2: begin
                if ((sb==1 && sa==0) || (sa==1 && sb==1 && counter >= 5))begin
                    next_state=state_3;
                end
                else begin 
                    next_state=state_2;
                end
            end
            state_3: begin
                next_state = state_0;
            end
            default:begin
                next_state = state_0;
            end
        endcase
    end
    always @(*) begin
        case (state)
            state_0: begin lb = GREEN;  la = RED;    end
            state_1: begin lb = YELLOW; la = RED;    end
            state_2: begin lb = RED;    la = GREEN;  end
            state_3: begin lb = RED;    la = YELLOW; end
            default: begin lb = RED;    la = RED;    end
        endcase
    end
endmodule
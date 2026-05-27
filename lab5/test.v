module test1
(
input	sys_clk,     //system clock 50Mhz on board
input	rstb,      //reset ,low active
output	uart_tx    //fpga send data
);

parameter CLK_FRE = 50;//Mhz
localparam [1:0] STATE_RESET = 0, STATE_SEND = 3;
// communication interface
reg [7:0] 	tx_data;
reg 		tx_data_valid;

reg [1:0] 	state;

// State transfer
always@(posedge sys_clk or negedge rstb)
begin
	if(~rstb)
	begin
		tx_data 		<= 8'd0;
		tx_data_valid 	<= 0;
		state 			<= STATE_RESET;
	end
	else
		case(state)
			STATE_SEND: begin
				if(tx_data_valid && tx_data_ready)//last byte sent is complete
				begin
					// "6" is 8'b00110110;
					// send from LSB to MSB: 01101100
					tx_data <= "6";
					tx_data_valid <= 1'b0;
				end
				else if(~tx_data_valid)
				begin
					tx_data_valid <= 1'b1;
				end
			end
			default: begin//STATE_RESET
				state 	<= STATE_SEND;
			end
		endcase
end

// UART Interface
uart_tx #
(
.CLK_FRE(CLK_FRE),
.BAUD_RATE(115200)
) uart_tx_inst
(
.clk 			(sys_clk),
.rst_n 			(rstb),
.tx_data  		(tx_data),
.tx_data_valid	(tx_data_valid),
.tx_data_ready	(tx_data_ready),
.tx_pin 		(uart_tx)
);
endmodule
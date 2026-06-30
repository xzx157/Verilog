module ProgramCounter (
  input   wire          clk,
  input   wire          reset,
  input         [15:0]  dataIn,
  output  wire  [15:0]  dataOut,
  input                 writeEnable,    // 1 => WRITE, 0 => READ
  input                 writeAdd,       // 1 => Add dataIn to PC, 0 => Set dataIn to PC
  input                 countEnable     // 1 => COUNT UP, 0 => STOPPED
);

reg [15:0] programCounter;

always @(posedge clk)
begin
	if (reset) begin
		programCounter <= 16'd0;
	end
	else if (writeEnable) begin
		programCounter <= writeAdd ? (programCounter + $signed(dataIn)) : dataIn;
	end
	else if (countEnable) begin
		programCounter <= programCounter + 16'd4;
	end
	else begin 
		programCounter <= programCounter;
	end
end

assign dataOut = programCounter;

endmodule

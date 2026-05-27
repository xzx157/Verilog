module RegisterFile #(
  parameter DataWidth  = 32,
  parameter NumRegs    = 32,
  parameter IndexWidth = $clog2(NumRegs)
) (
  input  clk,
  input  writeEn,
  input  [IndexWidth-1:0] writeAddr,
  input  [ DataWidth-1:0] writeData,
  input  [IndexWidth-1:0] readAddr1,
  input  [IndexWidth-1:0] readAddr2,
  output [ DataWidth-1:0] readData1,
  output [ DataWidth-1:0] readData2
);

  logic [DataWidth-1:0] regs[NumRegs];

  always_ff @(posedge clk) begin
    if (writeEn) begin
      regs[writeAddr] <= writeData;
    end
  end

  assign readData1 = regs[readAddr1];
  assign readData2 = regs[readAddr2];

endmodule
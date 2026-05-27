module fifo (
input   clk             , // Clock input
input   rstb            , // Reset all function, low active
input   rd              , // Pop one datum out
input   wr              , // Push one datum in
input   [15:0] data_in  , // Data input port
output  [15:0] data_out , // Data output port
output  empty           , // FIFO empty indicator, high active
output  full              // FIFO full indicator, low active
);  

	localparam ADDR_WIDTH = 8;
	localparam DEPTH = 1 << ADDR_WIDTH;

	reg [ADDR_WIDTH-1:0] wr_addr;
	reg [ADDR_WIDTH-1:0] rd_addr;
	reg [ADDR_WIDTH:0] count;

	localparam [ADDR_WIDTH-1:0] LAST_ADDR = DEPTH - 1;
	reg [ADDR_WIDTH-1:0] ram_addr;
	reg web;
	wire cs;
	reg oe;

	assign empty = (count == 0);
	assign full = (count == DEPTH);

	wire rd_en = rd && !empty;
    wire wr_en = wr && !full;

	assign cs = 1'b1;


	always @* begin
		ram_addr = rd_addr;
		web = 1'b1;
		if (wr_en) begin
			ram_addr = wr_addr;
			web = 1'b0;
		end else if (rd_en) begin
			ram_addr = rd_addr;
			web = 1'b1;
		end
	end

	ram_sr #(.DATA_WIDTH(16), .ADDR_WIDTH(ADDR_WIDTH)) u_ram (
		.clk( clk )
		,.address ( ram_addr )
		,.d  ( data_in )
		,.q ( data_out )
		,.cs ( cs )
		,.web ( web )
		,.oe ( oe )
	);

	always @(posedge clk) begin
        oe <= rd_en;
		if (!rstb) begin
			wr_addr <= {ADDR_WIDTH{1'b0}};
			rd_addr <= {ADDR_WIDTH{1'b0}};
			count <= {ADDR_WIDTH+1{1'b0}};
		end else begin
			if (wr_en) begin
				wr_addr <= (wr_addr == LAST_ADDR) ? {ADDR_WIDTH{1'b0}} : (wr_addr + 1'b1);
				count <= count + 1'b1;
			end else if (rd_en) begin
				rd_addr <= (rd_addr == LAST_ADDR) ? {ADDR_WIDTH{1'b0}} : (rd_addr + 1'b1);
				count <= count - 1'b1;
			end
	end
    end
endmodule
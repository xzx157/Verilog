`timescale 1ns/1ns
`default_nettype none

module accelerator_top (
    input  wire        clk,
    input  wire        comp_enb,
    output reg  [15:0] mem_addr,
    input  wire [63:0] mem_data,
    output reg         mem_read_enb,
    output reg         mem_write_enb,
    output reg  [16:0] res_addr,
    output reg  [63:0] res_data,
    output reg         busyb,
    output reg         done
);

    localparam integer MATRIX_SIZE = 512;
    localparam integer TILE_ROWS   = 4;
    localparam integer TILE_COLS   = 8;
    localparam integer A_BANKS     = 1;
    localparam integer B_BANKS     = 2;
    localparam integer ACC_BITS    = 25;

    localparam [15:0] B_BASE = 16'd32768;

    localparam [4:0] S_IDLE          = 5'd0;
    localparam [4:0] S_INIT_TILE     = 5'd1;
    localparam [4:0] S_LOAD_A_ADDR   = 5'd2;
    localparam [4:0] S_LOAD_A_WRITE  = 5'd3;
    localparam [4:0] S_LOAD_B0_ADDR  = 5'd4;
    localparam [4:0] S_LOAD_B0_WRITE = 5'd5;
    localparam [4:0] S_LOAD_B1_ADDR  = 5'd6;
    localparam [4:0] S_LOAD_B1_WRITE = 5'd7;
    localparam [4:0] S_COMPUTE_ADDR  = 5'd8;
    localparam [4:0] S_COMPUTE_WAIT  = 5'd9;
    localparam [4:0] S_COMPUTE_PULSE = 5'd10;
    localparam [4:0] S_WRITE_SETUP   = 5'd11;
    localparam [4:0] S_WRITE_HOLD    = 5'd12;
    localparam [4:0] S_NEXT_TILE     = 5'd13;
    localparam [4:0] S_DONE          = 5'd14;

    reg [4:0] state;
    reg       rst_n_int;

    reg [9:0] row_base;
    reg [9:0] col_base;
    reg [8:0] load_k;
    reg [8:0] compute_k;
    reg [3:0] load_row;
    reg [3:0] write_row;
    reg [2:0] write_word;
    reg       b_tile_valid;
    reg [31:0] a_pack_data;

    reg         a_sram_cs_n [0:A_BANKS-1];
    reg         a_sram_we_n [0:A_BANKS-1];
    reg [8:0]   a_sram_addr [0:A_BANKS-1];
    reg [31:0]  a_sram_wdata [0:A_BANKS-1];
    wire [31:0] a_sram_rdata [0:A_BANKS-1];

    reg         b_sram_cs_n [0:B_BANKS-1];
    reg         b_sram_we_n [0:B_BANKS-1];
    reg [8:0]   b_sram_addr [0:B_BANKS-1];
    reg [31:0]  b_sram_wdata [0:B_BANKS-1];
    wire [31:0] b_sram_rdata [0:B_BANKS-1];

    wire signed [7:0] a_core_in [0:TILE_ROWS-1];
    wire signed [7:0] b_core_in [0:TILE_COLS-1];
    wire signed [ACC_BITS-1:0] c_mat [0:TILE_ROWS-1][0:TILE_COLS-1];

    integer idx;
    genvar bank;

    wire array_clear = (state == S_INIT_TILE);
    wire array_pulse = (state == S_COMPUTE_PULSE);

    function signed [7:0] get_byte;
        input [63:0] word;
        input [2:0] index;
        begin
            case (index)
                3'd0: get_byte = word[63:56];
                3'd1: get_byte = word[55:48];
                3'd2: get_byte = word[47:40];
                3'd3: get_byte = word[39:32];
                3'd4: get_byte = word[31:24];
                3'd5: get_byte = word[23:16];
                3'd6: get_byte = word[15:8];
                default: get_byte = word[7:0];
            endcase
        end
    endfunction

    function [63:0] set_byte;
        input [63:0] word;
        input [2:0] index;
        input [7:0] value;
        begin
            set_byte = word;
            case (index)
                3'd0: set_byte[63:56] = value;
                3'd1: set_byte[55:48] = value;
                3'd2: set_byte[47:40] = value;
                3'd3: set_byte[39:32] = value;
                3'd4: set_byte[31:24] = value;
                3'd5: set_byte[23:16] = value;
                3'd6: set_byte[15:8]  = value;
                default: set_byte[7:0] = value;
            endcase
        end
    endfunction

    function [31:0] set_byte32;
        input [31:0] word;
        input [1:0] index;
        input [7:0] value;
        begin
            set_byte32 = word;
            case (index)
                2'd0: set_byte32[31:24] = value;
                2'd1: set_byte32[23:16] = value;
                2'd2: set_byte32[15:8]  = value;
                default: set_byte32[7:0] = value;
            endcase
        end
    endfunction

    function [31:0] to_int32;
        input signed [ACC_BITS-1:0] value;
        begin
            to_int32 = {{(32-ACC_BITS){value[ACC_BITS-1]}}, value};
        end
    endfunction

    function [15:0] matrix_word_addr;
        input [9:0] row_i;
        input [5:0] word_i;
        begin
            matrix_word_addr = {row_i, 6'b0} + {10'd0, word_i};
        end
    endfunction

    function [16:0] result_word_addr;
        input [9:0] row_i;
        input [7:0] word_i;
        begin
            result_word_addr = {row_i, 8'b0} + {9'd0, word_i};
        end
    endfunction

    generate
        for (bank = 0; bank < A_BANKS; bank = bank + 1) begin : gen_a_sram
            sram_model #(
                .ADDR_WIDTH(9),
                .DATA_WIDTH(32)
            ) u_a_sram (
                .clk(clk),
                .rst_n(rst_n_int),
                .cs_n(a_sram_cs_n[bank]),
                .we_n(a_sram_we_n[bank]),
                .addr(a_sram_addr[bank]),
                .wdata(a_sram_wdata[bank]),
                .rdata(a_sram_rdata[bank])
            );
        end

        for (bank = 0; bank < B_BANKS; bank = bank + 1) begin : gen_b_sram
            sram_model #(
                .ADDR_WIDTH(9),
                .DATA_WIDTH(32)
            ) u_b_sram (
                .clk(clk),
                .rst_n(rst_n_int),
                .cs_n(b_sram_cs_n[bank]),
                .we_n(b_sram_we_n[bank]),
                .addr(b_sram_addr[bank]),
                .wdata(b_sram_wdata[bank]),
                .rdata(b_sram_rdata[bank])
            );
        end

        for (bank = 0; bank < TILE_ROWS; bank = bank + 1) begin : gen_a_core_in
            assign a_core_in[bank] = $signed(a_sram_rdata[0][(3-bank)*8 +: 8]);
        end

        for (bank = 0; bank < TILE_COLS; bank = bank + 1) begin : gen_b_core_in
            assign b_core_in[bank] = $signed(b_sram_rdata[bank / 4][(3-(bank % 4))*8 +: 8]);
        end
    endgenerate

    accelerator_sram_ext #(
        .ROWS(TILE_ROWS),
        .COLS(TILE_COLS),
        .ACC_BITS(ACC_BITS)
    ) u_compute_core (
        .clk(clk),
        .rst_n(rst_n_int),
        .clear_acc(array_clear),
        .pulse_en(array_pulse),
        .a_row_in(a_core_in),
        .b_col_in(b_core_in),
        .c_out(c_mat)
    );

    always @* begin
        for (idx = 0; idx < A_BANKS; idx = idx + 1) begin
            a_sram_cs_n[idx]  = 1'b1;
            a_sram_we_n[idx]  = 1'b1;
            a_sram_addr[idx]  = compute_k;
            a_sram_wdata[idx] = 32'd0;
        end
        for (idx = 0; idx < B_BANKS; idx = idx + 1) begin
            b_sram_cs_n[idx]  = 1'b1;
            b_sram_we_n[idx]  = 1'b1;
            b_sram_addr[idx]  = compute_k;
            b_sram_wdata[idx] = 32'd0;
        end

        if ((state == S_LOAD_A_WRITE) && (load_row == 4'd3)) begin
            a_sram_cs_n[0]  = 1'b0;
            a_sram_we_n[0]  = 1'b0;
            a_sram_addr[0]  = load_k;
            a_sram_wdata[0] = set_byte32(a_pack_data, load_row[1:0], get_byte(mem_data, load_k[2:0]));
        end else if (state == S_LOAD_B0_WRITE) begin
            for (idx = 0; idx < B_BANKS; idx = idx + 1) begin
                b_sram_cs_n[idx]  = 1'b0;
                b_sram_we_n[idx]  = 1'b0;
                b_sram_addr[idx]  = load_k;
            end
            b_sram_wdata[0] = mem_data[63:32];
            b_sram_wdata[1] = mem_data[31:0];
        end else if ((state == S_COMPUTE_ADDR) || (state == S_COMPUTE_WAIT) || (state == S_COMPUTE_PULSE)) begin
            for (idx = 0; idx < A_BANKS; idx = idx + 1) begin
                a_sram_cs_n[idx] = 1'b0;
                a_sram_we_n[idx] = 1'b1;
                a_sram_addr[idx] = compute_k;
            end
            for (idx = 0; idx < B_BANKS; idx = idx + 1) begin
                b_sram_cs_n[idx] = 1'b0;
                b_sram_we_n[idx] = 1'b1;
                b_sram_addr[idx] = compute_k;
            end
        end
    end

    always @(posedge clk) begin
        if (comp_enb) begin
            state         <= S_IDLE;
            rst_n_int     <= 1'b0;
            row_base      <= 10'd0;
            col_base      <= 10'd0;
            load_k        <= 9'd0;
            compute_k     <= 9'd0;
            load_row      <= 4'd0;
            write_row     <= 4'd0;
            write_word    <= 1'b0;
            b_tile_valid  <= 1'b0;
            a_pack_data   <= 32'd0;
            mem_addr      <= 16'd0;
            mem_read_enb  <= 1'b0;
            mem_write_enb <= 1'b1;
            res_addr      <= 17'd0;
            res_data      <= 64'd0;
            done          <= 1'b0;
        end else begin
            rst_n_int     <= 1'b1;
            mem_read_enb  <= 1'b0;
            mem_write_enb <= 1'b1;
            done          <= 1'b0;

            case (state)
                S_IDLE: begin
                    row_base <= 10'd0;
                    col_base <= 10'd0;
                    state    <= S_INIT_TILE;
                end

                S_INIT_TILE: begin
                    load_k     <= 9'd0;
                    compute_k  <= 9'd0;
                    load_row   <= 4'd0;
                    write_row  <= 4'd0;
                    write_word <= 3'd0;
                    a_pack_data <= 32'd0;
                    if (b_tile_valid) begin
                        state <= S_LOAD_A_ADDR;
                    end else begin
                        state <= S_LOAD_B0_ADDR;
                    end
                end

                S_LOAD_A_ADDR: begin
                    if ((row_base + {6'd0, load_row}) < MATRIX_SIZE) begin
                        mem_addr <= matrix_word_addr(row_base + {6'd0, load_row}, load_k[8:3]);
                    end
                    state <= S_LOAD_A_WRITE;
                end

                S_LOAD_A_WRITE: begin
                    a_pack_data <= set_byte32(a_pack_data, load_row[1:0], get_byte(mem_data, load_k[2:0]));
                    if (load_row == 4'd3) begin
                        load_row <= 4'd0;
                        a_pack_data <= 32'd0;
                        if (load_k == 9'd511) begin
                            load_k <= 9'd0;
                            state  <= S_COMPUTE_ADDR;
                        end else begin
                            load_k <= load_k + 9'd1;
                            state  <= S_LOAD_A_ADDR;
                        end
                    end else begin
                        load_row <= load_row + 4'd1;
                        state    <= S_LOAD_A_ADDR;
                    end
                end

                S_LOAD_B0_ADDR: begin
                    mem_addr <= B_BASE + matrix_word_addr({1'b0, load_k}, col_base[8:3]);
                    state    <= S_LOAD_B0_WRITE;
                end

                S_LOAD_B0_WRITE: begin
                    if (load_k == 9'd511) begin
                        b_tile_valid <= 1'b1;
                        load_k       <= 9'd0;
                        load_row     <= 4'd0;
                        state        <= S_LOAD_A_ADDR;
                    end else begin
                        load_k <= load_k + 9'd1;
                        state  <= S_LOAD_B0_ADDR;
                    end
                end

                S_COMPUTE_ADDR: begin
                    state <= S_COMPUTE_WAIT;
                end

                S_COMPUTE_WAIT: begin
                    state <= S_COMPUTE_PULSE;
                end

                S_COMPUTE_PULSE: begin
                    if (compute_k == 9'd511) begin
                        write_row  <= 4'd0;
                        write_word <= 3'd0;
                        state      <= S_WRITE_SETUP;
                    end else begin
                        compute_k <= compute_k + 9'd1;
                        state     <= S_COMPUTE_ADDR;
                    end
                end

                S_WRITE_SETUP: begin
                    if ((row_base + {6'd0, write_row}) >= MATRIX_SIZE) begin
                        state <= S_NEXT_TILE;
                    end else begin
                        res_addr <= result_word_addr(row_base + {6'd0, write_row}, col_base[8:1] + {5'd0, write_word});
                        res_data <= {
                            to_int32(c_mat[write_row][{write_word, 1'b0}]),
                            to_int32(c_mat[write_row][{write_word, 1'b0} + 4'd1])
                        };
                        mem_write_enb <= 1'b0;
                        state         <= S_WRITE_HOLD;
                    end
                end

                S_WRITE_HOLD: begin
                    mem_write_enb <= 1'b0;
                    if (write_word != 3'd3) begin
                        write_word <= write_word + 3'd1;
                        state      <= S_WRITE_SETUP;
                    end else begin
                        write_word <= 3'd0;
                        if (write_row == 4'd3) begin
                            write_row <= 4'd0;
                            state     <= S_NEXT_TILE;
                        end else begin
                            write_row <= write_row + 4'd1;
                            state     <= S_WRITE_SETUP;
                        end
                    end
                end

                S_NEXT_TILE: begin
                    if ((row_base + TILE_ROWS) < MATRIX_SIZE) begin
                        row_base <= row_base + TILE_ROWS;
                        state    <= S_INIT_TILE;
                    end else begin
                        row_base <= 10'd0;
                        if (col_base == 10'd504) begin
                            state <= S_DONE;
                        end else begin
                            col_base     <= col_base + TILE_COLS;
                            b_tile_valid <= 1'b0;
                            state        <= S_INIT_TILE;
                        end
                    end
                end

                S_DONE: begin
                    done  <= 1'b1;
                    state <= S_DONE;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

    always @* begin
        busyb = 1'b0;
        if (comp_enb || (state == S_IDLE) || (state == S_DONE)) begin
            busyb = 1'b1;
        end
    end

endmodule

`default_nettype wire

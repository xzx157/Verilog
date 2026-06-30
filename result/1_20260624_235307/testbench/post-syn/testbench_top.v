`timescale 1ns/1ps
`default_nettype none

module testbench_top;

    localparam integer ROWS = 12;
    localparam integer COLS = 16;
    localparam integer ACC_BITS = 32;
    localparam integer K_STEPS = 32;
    localparam integer T = 2;

    reg clk = 1'b0;
    reg rst_n;
    reg clear_acc;
    reg pulse_en;
    reg signed [15:0] a_sram_rdata [0:ROWS-1];
    reg signed [15:0] b_sram_rdata [0:COLS-1];
`ifdef GATE
    reg  [ROWS*16-1:0] a_sram_rdata_flat;
    reg  [COLS*16-1:0] b_sram_rdata_flat;
    wire [ROWS*COLS*ACC_BITS-1:0] c_out_flat;
`else
    wire signed [ACC_BITS-1:0] c_out [0:ROWS-1][0:COLS-1];
`endif

    integer row;
    integer col;
    integer k;
    integer errors;
    integer expected [0:ROWS-1][0:COLS-1];
    integer a_tmp;
    integer b_tmp;

    always #(T/2) clk = ~clk;

`ifdef GATE
    accelerator_logic_top u_dut (
        .clk(clk),
        .rst_n(rst_n),
        .clear_acc(clear_acc),
        .pulse_en(pulse_en),
        .a_sram_rdata(a_sram_rdata_flat),
        .b_sram_rdata(b_sram_rdata_flat),
        .c_out(c_out_flat)
    );
`else
    accelerator_logic_top #(
        .ROWS(ROWS),
        .COLS(COLS),
        .ACC_BITS(ACC_BITS)
    ) u_dut (
        .clk(clk),
        .rst_n(rst_n),
        .clear_acc(clear_acc),
        .pulse_en(pulse_en),
        .a_sram_rdata(a_sram_rdata),
        .b_sram_rdata(b_sram_rdata),
        .c_out(c_out)
    );
`endif

    function signed [7:0] a_value;
        input integer row_i;
        input integer k_i;
        integer value;
        begin
            value = ((row_i * 3 + k_i * 5) % 17) - 8;
            a_value = value;
        end
    endfunction

    function signed [7:0] b_value;
        input integer col_i;
        input integer k_i;
        integer value;
        begin
            value = ((col_i * 7 + k_i * 2) % 19) - 9;
            b_value = value;
        end
    endfunction

    task drive_inputs;
        input integer k_i;
        begin
            for (row = 0; row < ROWS; row = row + 1) begin
                a_tmp = a_value(row, k_i);
                a_sram_rdata[row] = {{8{a_tmp[7]}}, a_tmp[7:0]};
`ifdef GATE
                a_sram_rdata_flat[(ROWS-1-row)*16 +: 16] = {{8{a_tmp[7]}}, a_tmp[7:0]};
`endif
            end
            for (col = 0; col < COLS; col = col + 1) begin
                b_tmp = b_value(col, k_i);
                b_sram_rdata[col] = {{8{b_tmp[7]}}, b_tmp[7:0]};
`ifdef GATE
                b_sram_rdata_flat[(COLS-1-col)*16 +: 16] = {{8{b_tmp[7]}}, b_tmp[7:0]};
`endif
            end
        end
    endtask

    function signed [ACC_BITS-1:0] observed_c;
        input integer row_i;
        input integer col_i;
        begin
`ifdef GATE
            observed_c = c_out_flat[(ROWS*COLS-1-(row_i*COLS+col_i))*ACC_BITS +: ACC_BITS];
`else
            observed_c = c_out[row_i][col_i];
`endif
        end
    endfunction

    initial begin
`ifdef SDF
        $sdf_annotate("../../syn/accelerator_logic_top_syn.sdf", u_dut);
`endif
    end

    initial begin
        rst_n = 1'b0;
        clear_acc = 1'b0;
        pulse_en = 1'b0;
        errors = 0;

        for (row = 0; row < ROWS; row = row + 1) begin
            a_sram_rdata[row] = 16'sd0;
`ifdef GATE
            a_sram_rdata_flat[(ROWS-1-row)*16 +: 16] = 16'd0;
`endif
            for (col = 0; col < COLS; col = col + 1) begin
                expected[row][col] = 0;
            end
        end
        for (col = 0; col < COLS; col = col + 1) begin
            b_sram_rdata[col] = 16'sd0;
`ifdef GATE
            b_sram_rdata_flat[(COLS-1-col)*16 +: 16] = 16'd0;
`endif
        end

        repeat (3) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        clear_acc = 1'b1;
        @(posedge clk);
        @(negedge clk);
        clear_acc = 1'b0;

        for (k = 0; k < K_STEPS; k = k + 1) begin
            @(negedge clk);
            drive_inputs(k);
            for (row = 0; row < ROWS; row = row + 1) begin
                for (col = 0; col < COLS; col = col + 1) begin
                    expected[row][col] = expected[row][col] + a_value(row, k) * b_value(col, k);
                end
            end
            pulse_en = 1'b1;
            @(posedge clk);
            @(negedge clk);
            pulse_en = 1'b0;
        end

        #1;
        for (row = 0; row < ROWS; row = row + 1) begin
            for (col = 0; col < COLS; col = col + 1) begin
                if (observed_c(row, col) !== expected[row][col]) begin
                    $display("[POST-SYN][ERROR] c_out[%0d][%0d]=%0d expected=%0d", row, col, observed_c(row, col), expected[row][col]);
                    errors = errors + 1;
                end
            end
        end

        if (errors == 0) begin
            $display("[POST-SYN] PASS");
        end else begin
            $display("[POST-SYN] FAIL errors=%0d", errors);
        end
        $finish;
    end

endmodule

`default_nettype wire

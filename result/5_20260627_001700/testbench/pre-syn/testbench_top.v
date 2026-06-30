
`timescale 1ns/1ps
`define T 2.0 // define macro for clock period

module testbench_top;

integer i, file1;
integer cycle_count;
reg done_seen;
reg latency_counting;
reg clk = 0;
always #(`T/2) clk = ~clk;
reg comp_enb;

wire [15:0] mem_addr;
wire [63:0] mem_data;
wire mem_read_enb;
wire mem_write_enb;
wire [16:0] res_addr;
wire [63:0] res_data;
wire busyb, done;

accelerator_top u_accelerator_top (
 .clk           (clk)
,.comp_enb      (comp_enb)
,.mem_addr      (mem_addr)
,.mem_data      (mem_data)
,.mem_read_enb  (mem_read_enb)
,.mem_write_enb (mem_write_enb)
,.res_addr      (res_addr)
,.res_data      (res_data)
,.busyb         (busyb)
,.done          (done)
);

ram #(.DATA_WIDTH(64), .ADDR_WIDTH(16)) u_input_mem (
 .clk       (clk)
,.web       (~mem_read_enb)
,.address   (mem_addr)
,.d         ({64{1'b0}})
,.q         (mem_data)
,.cs        (1'b1)
);

ram #(.DATA_WIDTH(64), .ADDR_WIDTH(17)) u_res_mem (
 .clk       (clk)
,.web       (mem_write_enb)
,.address   (res_addr)
,.d         (res_data)
,.q         (),
.cs         (1'b1)
);

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
always @(posedge clk) begin
    if (comp_enb) begin
        cycle_count <= 0;
        latency_counting <= 1'b1;
    end else if (latency_counting) begin
        if (done === 1'b1) begin
            $display("[TB][LATENCY] cycles=%0d", cycle_count);
            latency_counting <= 1'b0;
        end else begin
            cycle_count <= cycle_count + 1;
        end
    end
end

initial begin
    // start simulation
    $readmemh("../../input_mem.csv", u_input_mem.mem);
    cycle_count = 0;
    latency_counting = 1'b0;
    comp_enb = 1;
    #(`T) comp_enb = 0;
    
    done_seen = 1'b0;
    fork : wait_done_or_timeout
        begin
            wait (done === 1'b1);
            done_seen = 1'b1;
            $display("[TB][LATENCY] cycles=%0d realtime_ns=%0.3f", cycle_count, $realtime);
        end
        begin
            #(100000000);
            if (!done_seen) begin
                $display("[TB][TIMEOUT] done was not asserted");
                $finish;
            end
        end
    join_any
    disable wait_done_or_timeout;

    file1=$fopen("../../result_mem.csv","w");
    for(i=0;i<131072;i=i+1)
        $fwrite( file1 , "%16h\n" , u_res_mem.mem[i]);
    $fclose(file1);
    $finish;
end
endmodule
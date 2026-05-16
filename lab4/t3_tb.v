`timescale 1ms / 1ms
`include "t2.v"
module tb_traffic_simulator;

    reg clk;
    reg reset;
    wire sa;
    wire sb;
    wire [1:0] la;
    wire [1:0] lb;

    verilog_fsm uut (
        .clk(clk),
        .reset(reset),
        .sa(sa),
        .sb(sb),
        .la(la),
        .lb(lb)
    );
    reg [7:0] queue_A; 
    reg [7:0] queue_B; 
    
    reg [31:0] total_waiting_A;
    reg [31:0] total_waiting_B;
    reg [31:0] clock_cycles;

    always #2500 clk = ~clk;

    localparam GREEN  = 2'b00;
    localparam YELLOW = 2'b01;
    localparam RED    = 2'b10;


    integer seed_A = 12345; 
    integer seed_B = 67890;
    integer arrA;
    integer arrB;


    assign sa = (queue_A != 0) || (arrA != 0);
    assign sb = (queue_B != 0) || (arrB != 0);

    initial begin
        arrA = 0;
        arrB = 0;
    end

    function integer abs;
        input integer val;
        begin
            abs = (val < 0) ? -val : val;
        end
    endfunction
    
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            arrA = 0;
            arrB = 0;
        end
        else begin
            arrA = abs($random(seed_A)) % 3;
            arrB = abs($random(seed_B)) % 3;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            queue_A <= 0;
            queue_B <= 0;
            total_waiting_A <= 0;
            total_waiting_B <= 0;
            clock_cycles <= 0;
        end 
        else begin
            clock_cycles <= clock_cycles + 1;
            if (la == GREEN) begin
                if (queue_A + arrA >= 2)
                    queue_A <= queue_A + arrA - 2;
                else
                    queue_A <= 0;
            end 
            else begin
                queue_A <= queue_A + arrA; 
            end

            if (lb == GREEN) begin
                if (queue_B + arrB >= 2)
                    queue_B <= queue_B + arrB - 2;
                else
                    queue_B <= 0;
            end 
            else begin
                queue_B <= queue_B + arrB; 
            end

            total_waiting_A <= total_waiting_A + queue_A;
            total_waiting_B <= total_waiting_B + queue_B;
        end
    end

    initial begin
        clk = 0;
        reset = 1;
        #500;
        reset = 0; 

        repeat (201) @(posedge clk);

        $display("period: %0d  (total time: %0d sec)", clock_cycles, clock_cycles * 5);
        $display("A average waiting cars: %f ", (1.0 * total_waiting_A) / clock_cycles);
        $display("B average waiting cars: %f ", (1.0 * total_waiting_B) / clock_cycles);
        $display("Total average waiting cars : %f ", ((1.0 * total_waiting_A) + (1.0 * total_waiting_B)) / clock_cycles);

        $finish;
    end

endmodule
`timescale 1ns/1ps

module tb_processor_4bit;

    reg clk;
    reg reset;

    wire [3:0] pc_out;
    wire [7:0] instruction_out;
    wire [3:0] alu_result_out;
    wire [3:0] r0;
    wire [3:0] r1;
    wire [3:0] r2;
    wire [3:0] r3;

    processor_4bit DUT(
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction_out(instruction_out),
        .alu_result_out(alu_result_out),
        .r0(r0),
        .r1(r1),
        .r2(r2),
        .r3(r3)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("processor_4bit.vcd");
        $dumpvars(0, tb_processor_4bit);

        clk = 0;
        reset = 1;

        $display("---------------------------------------------------------------");
        $display("          DESIGN AND SIMULATION OF 4-BIT PROCESSOR");
        $display("---------------------------------------------------------------");
        $display("Time\tPC\tInstruction\tR0\tR1\tR2\tR3\tALU");
        $display("---------------------------------------------------------------");

        #10;
        reset = 0;

        #180;

        $display("---------------------------------------------------------------");
        $display("Final Register Values:");
        $display("R0 = %d", r0);
        $display("R1 = %d", r1);
        $display("R2 = %d", r2);
        $display("R3 = %d", r3);
        $display("---------------------------------------------------------------");

        $finish;
    end

    always @(posedge clk) begin
        if (!reset) begin
            $display("%0t\t%d\t%b\t%d\t%d\t%d\t%d\t%d",
                     $time, pc_out, instruction_out, r0, r1, r2, r3, alu_result_out);
        end
    end

endmodule

module alu_4bit(
    input  [3:0] a,
    input  [3:0] b,
    input  [2:0] alu_sel,
    output reg [3:0] result,
    output zero
);
    always @(*) begin
        case (alu_sel)
            3'b000: result = a + b;        // ADD
            3'b001: result = a - b;        // SUB
            3'b010: result = a & b;        // AND
            3'b011: result = a | b;        // OR
            3'b100: result = a ^ b;        // XOR
            3'b101: result = ~a;           // NOT
            3'b110: result = a << 1;       // Shift Left
            3'b111: result = a >> 1;       // Shift Right
            default: result = 4'b0000;
        endcase
    end

    assign zero = (result == 4'b0000);
endmodule


module register_file_4bit(
    input clk,
    input reset,
    input write_enable,
    input [1:0] write_addr,
    input [1:0] read_addr1,
    input [1:0] read_addr2,
    input [3:0] write_data,
    output [3:0] read_data1,
    output [3:0] read_data2,
    output [3:0] r0,
    output [3:0] r1,
    output [3:0] r2,
    output [3:0] r3
);
    reg [3:0] registers [0:3];

    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];

    assign r0 = registers[0];
    assign r1 = registers[1];
    assign r2 = registers[2];
    assign r3 = registers[3];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0] <= 4'd0;
            registers[1] <= 4'd0;
            registers[2] <= 4'd0;
            registers[3] <= 4'd0;
        end else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end
endmodule


module processor_4bit(
    input clk,
    input reset,
    output [3:0] pc_out,
    output [7:0] instruction_out,
    output [3:0] alu_result_out,
    output [3:0] r0,
    output [3:0] r1,
    output [3:0] r2,
    output [3:0] r3
);
    reg [3:0] pc;
    reg [7:0] program_memory [0:15];

    reg [3:0] immediate;
    reg write_enable;
    reg [1:0] write_addr;
    reg [1:0] read_addr1;
    reg [1:0] read_addr2;
    reg [2:0] alu_sel;
    reg [3:0] write_data;

    wire [7:0] instruction;
    wire [3:0] read_data1;
    wire [3:0] read_data2;
    wire [3:0] alu_result;
    wire zero;

    /*
    Instruction Set:

    0000 dddd : LOAD immediate to R0
    0001 dddd : LOAD immediate to R1
    0010 dddd : LOAD immediate to R2
    0011 dddd : LOAD immediate to R3
    0100 xxxx : R0 = R0 + R1
    0101 xxxx : R0 = R0 - R1
    0110 xxxx : R2 = R0 AND R1
    0111 xxxx : R3 = R0 OR R1
    1000 xxxx : R0 = R0 XOR R1
    1001 xxxx : R0 = NOT R0
    1010 xxxx : R0 = R0 << 1
    1011 xxxx : R0 = R0 >> 1
    1111 xxxx : HALT
    */

    initial begin
        program_memory[0]  = 8'b0000_0001; // R0 = 1
        program_memory[1]  = 8'b0001_0010; // R1 = 2
        program_memory[2]  = 8'b0100_0000; // R0 = R0 + R1 = 3
        program_memory[3]  = 8'b1010_0000; // R0 = R0 << 1 = 6
        program_memory[4]  = 8'b0001_0101; // R1 = 5
        program_memory[5]  = 8'b0101_0000; // R0 = R0 - R1 = 1
        program_memory[6]  = 8'b0010_1111; // R2 = 15
        program_memory[7]  = 8'b0110_0000; // R2 = R0 AND R1
        program_memory[8]  = 8'b0111_0000; // R3 = R0 OR R1
        program_memory[9]  = 8'b1000_0000; // R0 = R0 XOR R1
        program_memory[10] = 8'b1001_0000; // R0 = NOT R0
        program_memory[11] = 8'b1010_0000; // R0 = R0 << 1
        program_memory[12] = 8'b1011_0000; // R0 = R0 >> 1
        program_memory[13] = 8'b0001_1110; // R1 = 14
        program_memory[14] = 8'b0100_0000; // R0 = R0 + R1
        program_memory[15] = 8'b1111_0000; // HALT
    end

    assign instruction = program_memory[pc];

    assign pc_out = pc;
    assign instruction_out = instruction;
    assign alu_result_out = alu_result;

    register_file_4bit RF(
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .r0(r0),
        .r1(r1),
        .r2(r2),
        .r3(r3)
    );

    alu_4bit ALU(
        .a(read_data1),
        .b(read_data2),
        .alu_sel(alu_sel),
        .result(alu_result),
        .zero(zero)
    );

    always @(*) begin
        write_enable = 1'b0;
        write_addr = 2'b00;
        read_addr1 = 2'b00;
        read_addr2 = 2'b01;
        alu_sel = 3'b000;
        write_data = 4'b0000;
        immediate = instruction[3:0];

        case (instruction[7:4])
            4'b0000: begin
                write_enable = 1'b1;
                write_addr = 2'b00;
                write_data = immediate;
            end

            4'b0001: begin
                write_enable = 1'b1;
                write_addr = 2'b01;
                write_data = immediate;
            end

            4'b0010: begin
                write_enable = 1'b1;
                write_addr = 2'b10;
                write_data = immediate;
            end

            4'b0011: begin
                write_enable = 1'b1;
                write_addr = 2'b11;
                write_data = immediate;
            end

            4'b0100: begin
                write_enable = 1'b1;
                write_addr = 2'b00;
                alu_sel = 3'b000;
                write_data = alu_result;
            end

            4'b0101: begin
                write_enable = 1'b1;
                write_addr = 2'b00;
                alu_sel = 3'b001;
                write_data = alu_result;
            end

            4'b0110: begin
                write_enable = 1'b1;
                write_addr = 2'b10;
                alu_sel = 3'b010;
                write_data = alu_result;
            end

            4'b0111: begin
                write_enable = 1'b1;
                write_addr = 2'b11;
                alu_sel = 3'b011;
                write_data = alu_result;
            end

            4'b1000: begin
                write_enable = 1'b1;
                write_addr = 2'b00;
                alu_sel = 3'b100;
                write_data = alu_result;
            end

            4'b1001: begin
                write_enable = 1'b1;
                write_addr = 2'b00;
                alu_sel = 3'b101;
                write_data = alu_result;
            end

            4'b1010: begin
                write_enable = 1'b1;
                write_addr = 2'b00;
                alu_sel = 3'b110;
                write_data = alu_result;
            end

            4'b1011: begin
                write_enable = 1'b1;
                write_addr = 2'b00;
                alu_sel = 3'b111;
                write_data = alu_result;
            end

            default: begin
                write_enable = 1'b0;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 4'd0;
        else if (instruction[7:4] != 4'b1111)
            pc <= pc + 1'b1;
        else
            pc <= pc;
    end
endmodule

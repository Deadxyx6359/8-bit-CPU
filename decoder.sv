`timescale 1ns/1ps

// Instruction Decoder
module decoder (
    input  logic [15:0] instr,
    output logic        we,
    output logic [2:0]  alu_op,
    output logic [1:0]  write_addr,
    output logic [1:0]  read_addr1,
    output logic [1:0]  read_addr2,
    output logic        immediate_select,
    output logic [7:0]  immediate
);
    assign alu_op           = instr[15:13];
    assign write_addr       = instr[12:11];
    assign read_addr1       = instr[12:11];
    assign read_addr2       = instr[10:9];
    assign immediate_select = instr[8];
    assign immediate        = instr[7:0];
    assign we               = 1'b1;
endmodule

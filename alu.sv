`timescale 1ns / 1ps
// ALU Module: ADD, SUB, MUL, SHR, AND, OR, XOR, NOT
module alu #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       opcode,
    output logic [WIDTH-1:0] result
);
    logic [WIDTH-1:0] add_res = a + b;
    logic [WIDTH-1:0] sub_res = a - b;
    logic [WIDTH-1:0] mul_res = a * b;
    logic [WIDTH-1:0] sr_res  = a >> 1;
    logic [WIDTH-1:0] and_res = a & b;
    logic [WIDTH-1:0] or_res  = a | b;
    logic [WIDTH-1:0] xor_res = a ^ b;
    logic [WIDTH-1:0] not_res = ~a;
    always_comb begin
        case (opcode)
            3'b000: result = add_res;
            3'b001: result = sub_res;
            3'b010: result = mul_res;
            3'b011: result = not_res;
            3'b100: result = sr_res;
            3'b101: result = and_res;
            3'b110: result = or_res;
            3'b111: result = xor_res;
            default: result = '0;
        endcase
    end
endmodule
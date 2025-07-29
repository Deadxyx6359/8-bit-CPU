`timescale 1ns/1ps

// // Register File: 4 x 8-bit registers
module regfile #(parameter WIDTH = 8, DEPTH = 4) (
    input  logic                   clk,
    input  logic                   rst,
    input  logic                   we,
    input  logic [$clog2(DEPTH)-1:0] write_addr,
    input  logic [$clog2(DEPTH)-1:0] read_addr1,
    input  logic [$clog2(DEPTH)-1:0] read_addr2,
    input  logic [WIDTH-1:0]       write_data,
    output logic [WIDTH-1:0]       read_data1,
    output logic [WIDTH-1:0]       read_data2
);
    logic [WIDTH-1:0] regs [0:DEPTH-1]; integer i;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) for (i=0;i<DEPTH;i++) regs[i]<=0;
        else if (we) regs[write_addr]<=write_data;
    end
    assign read_data1 = regs[read_addr1];
    assign read_data2 = regs[read_addr2];
endmodule
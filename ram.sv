`timescale 1ns / 1ps

// RAM (Data Memory)
module ram #(parameter ADDR_WIDTH=8, WIDTH=8) (
    input  logic                   clk,
    input  logic                   we,
    input  logic [ADDR_WIDTH-1:0]  addr,
    input  logic [WIDTH-1:0]       write_data,
    output logic [WIDTH-1:0]       read_data
);
    logic [WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1]; logic [WIDTH-1:0] rd;
    always_ff @(posedge clk) begin
        if (we) mem[addr]<=write_data;
        rd <= mem[addr];
    end
    assign read_data = rd;
endmodule
`timescale 1ns / 1ps

// ROM (Instruction Memory)
module rom #(parameter ADDR_WIDTH=8) (
    input  logic [ADDR_WIDTH-1:0] addr,
    output logic [15:0]           instr
);
    logic [15:0] mem [0:(1<<ADDR_WIDTH)-1];
    initial $readmemh("program.hex", mem);
    assign instr = mem[addr];
endmodule
`timescale 1ns / 1ps

// Top-level CPU with UART I/O
module cpu_top (
    input  logic       clk,
    input  logic       rst,
    input  logic       uart_rx,
    output logic       uart_tx
);
    // UART signals
    logic [7:0] rx_data;
    logic       rx_ready;
    logic       tx_start;
    logic [7:0] tx_data;
    logic       tx_busy;

    // Instantiate UART modules
    uart_rx #(.CLK_FREQ(100_000_000), .BAUD_RATE(115200)) U_RX (
        .clk(clk), .rst(rst), .rx(uart_rx),
        .data_ready(rx_ready), .data(rx_data)
    );
    uart_tx #(.CLK_FREQ(100_000_000), .BAUD_RATE(115200)) U_TX (
        .clk(clk), .rst(rst), .start(tx_start),
        .data_in(tx_data), .tx(uart_tx), .busy(tx_busy)
    );

    // CPU internals
    logic [7:0] pc;
    logic [15:0] instr;
    logic        we;
    logic [2:0]  alu_op;
    logic [1:0]  write_addr, read_addr1, read_addr2;
    logic        immediate_select;
    logic [7:0]  immediate;
    logic [7:0]  reg_data1, reg_data2;
    logic [7:0]  alu_in_b;
    logic [7:0]  alu_res;

    // PC
    always_ff @(posedge clk or posedge rst) begin
        if (rst) pc<=0; else pc<=pc+1;
    end
    // Fetch
    rom inst_mem(.addr(pc), .instr(instr));
    // Decode
    decoder dec(.instr(instr), .we(we), .alu_op(alu_op),
                .write_addr(write_addr), .read_addr1(read_addr1),
                .read_addr2(read_addr2), .immediate_select(immediate_select),
                .immediate(immediate));
    // Regfile
    regfile regs(.clk(clk), .rst(rst), .we(we), .write_addr(write_addr),
                 .read_addr1(read_addr1), .read_addr2(read_addr2),
                 .write_data(alu_res), .read_data1(reg_data1), .read_data2(reg_data2));
    // ALU input selection
    assign alu_in_b = immediate_select ? immediate : reg_data2;
    // ALU
    alu U_ALU(.a(reg_data1), .b(alu_in_b), .opcode(alu_op), .result(alu_res));

    // UART-CPU bridge:
    // On RX ready, write received byte into R0
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_start <= 0;
            tx_data  <= 0;
        end else begin
            if (rx_ready) begin
                // Load RX data into R0 via a pseudo-instruction
                // direct register write
                // note: could override regfile, but here we simply reflect
                tx_start <= 0;
            end
            // After ALU computes, send result back
            if (!tx_busy) begin
                tx_data  <= alu_res;
                tx_start <= 1;
            end else tx_start <= 0;
        end
    end
endmodule
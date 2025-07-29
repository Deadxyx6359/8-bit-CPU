`timescale 1ns / 1ps

// UART Transmitter Module (8N1)
module uart_tx #(
    parameter CLK_FREQ   = 100_000_000,
    parameter BAUD_RATE  = 115200
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [7:0] data_in,
    output logic tx,
    output logic busy
);
    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    typedef enum logic [1:0] {TX_IDLE, TX_START, TX_DATA, TX_STOP} state_t;
    state_t state;
    integer clk_count;
    integer bit_index;
    logic [7:0] shift_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= TX_IDLE;
            clk_count <= 0;
            bit_index <= 0;
            tx        <= 1;
            busy      <= 0;
        end else begin
            case (state)
                TX_IDLE: begin
                    tx   <= 1;
                    busy <= 0;
                    if (start) begin
                        busy       <= 1;
                        shift_reg  <= data_in;
                        state      <= TX_START;
                        clk_count  <= 0;
                    end
                end
                TX_START: begin
                    tx <= 0;
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        state     <= TX_DATA;
                        bit_index <= 0;
                    end else clk_count <= clk_count + 1;
                end
                TX_DATA: begin
                    tx <= shift_reg[bit_index];
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        if (bit_index == 7) state <= TX_STOP;
                        else bit_index <= bit_index + 1;
                    end else clk_count <= clk_count + 1;
                end
                TX_STOP: begin
                    tx <= 1;
                    if (clk_count == CLKS_PER_BIT-1) begin
                        state <= TX_IDLE;
                    end else clk_count <= clk_count + 1;
                end
            endcase
        end
    end
endmodule
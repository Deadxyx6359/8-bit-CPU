`timescale 1ns / 1ps
// UART Receiver Module (8N1)
module uart_rx #(
    parameter CLK_FREQ   = 100_000_000,
    parameter BAUD_RATE  = 115200
)(
    input  logic clk,
    input  logic rst,
    input  logic rx,
    output logic data_ready,
    output logic [7:0] data
);
    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;
    integer clk_count;
    integer bit_index;
    logic [7:0] shift_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state      <= IDLE;
            clk_count  <= 0;
            bit_index  <= 0;
            data_ready <= 0;
            data       <= 0;
        end else begin
            data_ready <= 0;
            case (state)
                IDLE: begin
                    if (!rx) begin // start bit detected (line low)
                        state     <= START;
                        clk_count <= 0;
                    end
                end
                START: begin
                    if (clk_count == CLKS_PER_BIT/2) begin
                        clk_count <= 0;
                        state     <= DATA;
                        bit_index <= 0;
                    end else clk_count <= clk_count + 1;
                end
                DATA: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count          <= 0;
                        shift_reg[bit_index] <= rx;
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else clk_count <= clk_count + 1;
                end
                STOP: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        data       <= shift_reg;
                        data_ready <= 1;
                        state      <= IDLE;
                        clk_count  <= 0;
                    end else clk_count <= clk_count + 1;
                end
            endcase
        end
    end
endmodule
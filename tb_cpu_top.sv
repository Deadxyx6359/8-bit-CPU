`timescale 1ns/1ps

// Simple 8-bit CPU with UART IO Updated Testbench
// tb_cpu_top.sv

module tb_cpu_top;
    // Clock & reset
    logic clk;
    logic rst;
    // UART lines
    logic uart_rx;
    logic uart_tx;

    // Instantiate Device Under Test
    cpu_top uut (
        .clk(clk),
        .rst(rst),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx)
    );

    // Parameters for UART bit period (ns)
    // 100 MHz clock to 10 ns period; 115200 baud to ~868 clock cycles => 8680 ns
    parameter integer BIT_PERIOD = 10;

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Dump waveform
    initial begin
        $dumpfile("tb_cpu_uart.vcd");
        $dumpvars(0, tb_cpu_top);
    end

    // Stimulus
    initial begin
        // Initialize
        rst     = 1;
        uart_rx = 1;         // Idle high
        #100;
        rst     = 0;
        #100;

        // Send a test byte into RX
        send_byte(8'h3A);
        // Wait for transmit to complete
        # (BIT_PERIOD * 12 * 2 + BIT_PERIOD);

        // Send another byte
        send_byte(8'hA5);
        # (BIT_PERIOD * 12 * 2 + BIT_PERIOD);

        // End simulation
        #1000;
        $finish;
    end

    // Task: send a byte over uartrx
    task send_byte(input [7:0] data);
        integer i;
        begin
            // Start bit
            uart_rx = 0;
            #(BIT_PERIOD);
            // Data bits (LSB first)
            for (i = 0; i < 8; i++) begin
                uart_rx = data[i];
                #(BIT_PERIOD);
            end
            // Stop bit
            uart_rx = 1;
            #(BIT_PERIOD);
        end
    endtask

    // Monitor UART TX bits
    always @(negedge uart_tx) begin
        $display("[%0t] UART TX start bit detected", $time);
    end
    always @(posedge uart_tx) begin
        $display("[%0t] UART TX stop bit detected", $time);
    end
endmodule


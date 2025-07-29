# 8-bit-CPU
This project implements a simple 8-bit CPU in SystemVerilog, targeted at the Digilent Basys-3 FPGA. The CPU supports basic arithmetic and logic operations, a small register file, instruction ROM and RAM, and a UART interface so you can send commands and receive results directly from your laptop.

Key Features
• ALU with eight operations: ADD, SUB, MUL (using the Basys-3 DSP/MAC block), logical shift right, AND, OR, XOR, and NOT
• Four 8-bit general-purpose registers (R0–R3)
• 16-bit instruction format: opcode (3 bits), destination register (2 bits), source register (2 bits), immediate flag (1 bit), and 8-bit immediate value
• UART receiver and transmitter running at 115,200 baud (with a 100 MHz system clock) for host ↔ CPU data exchange
• A self-contained SystemVerilog testbench that drives UART_RX, monitors UART_TX, preloads the instruction ROM, and generates waveform dumps

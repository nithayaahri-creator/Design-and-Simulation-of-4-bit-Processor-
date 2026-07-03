# Design and Simulation of 4-bit Processor using Verilog HDL

## Project Overview

This project presents the design and simulation of a simple 4-bit processor using Verilog HDL.  
The processor executes a custom instruction set and performs arithmetic and logical operations using a 4-bit ALU.

This project was completed as part of the **Digital Electronics and VLSI Internship**.

---

## Objective

The main objective of this project is to design a basic processor architecture and understand the working of important digital blocks such as:

- ALU
- Register File
- Control Unit
- Program Counter
- Program Memory
- Instruction Decoder

---

## Main Components

### 1. ALU

The Arithmetic Logic Unit performs arithmetic and logical operations such as addition, subtraction, AND, OR, XOR, NOT, shift left, and shift right.

### 2. Register File

The register file contains four 4-bit registers named R0, R1, R2, and R3.  
These registers store data during processor execution.

### 3. Program Counter

The program counter stores the address of the current instruction.  
It increments after each clock cycle to fetch the next instruction.

### 4. Program Memory

The program memory stores the instructions that are executed by the processor.

### 5. Control Unit

The control unit decodes the instruction and activates the required operation in the processor.

---

## Instruction Set

| Opcode | Operation |
|---|---|
| 0000 | Load immediate value to R0 |
| 0001 | Load immediate value to R1 |
| 0010 | Load immediate value to R2 |
| 0011 | Load immediate value to R3 |
| 0100 | Addition: R0 = R0 + R1 |
| 0101 | Subtraction: R0 = R0 - R1 |
| 0110 | AND operation |
| 0111 | OR operation |
| 1000 | XOR operation |
| 1001 | NOT operation |
| 1010 | Shift left |
| 1011 | Shift right |
| 1111 | Halt |

---

## Tools Used

- Verilog HDL
- EDA Playground
- Icarus Verilog
- EPWave

---

## Simulation Result

The 4-bit processor was simulated using EDA Playground.  
The output was verified using EPWave digital waveform simulation.

The simulation verifies:

- Clock signal operation
- Reset operation
- Program counter increment
- Instruction execution
- ALU output changes
- Register value changes

---

## Simulation Screenshots

### Code / Simulation Screenshot 1

![Screenshot 431](Screenshot%20(431).png)

### Code / Simulation Screenshot 2

![Screenshot 433](Screenshot%20(433).png)

### Waveform Output

![Screenshot 434](Screenshot%20(434).png)

---

## Output Verification

The waveform output shows the digital operation of the 4-bit processor.  
The clock signal controls the execution of instructions.  
The program counter increments step by step and fetches instructions from program memory.  
The register outputs R0, R1, R2, and R3 change according to LOAD and ALU operations.

---

## Conclusion

The 4-bit processor was successfully designed and simulated using Verilog HDL.  
This project helped in understanding processor architecture, instruction execution, ALU operations, register file design, and waveform-based verification.

---

## Project Status

Completed successfully.

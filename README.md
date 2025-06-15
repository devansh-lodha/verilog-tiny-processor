# Simple 8-Bit Processor in Verilog

This repository contains the Verilog source code and documentation for a simple 8-bit, accumulator-based processor. The project was developed as part of the ES 204: Digital Systems course at the Indian Institute of Technology Gandhinagar.

The processor features a custom Instruction Set Architecture (ISA), a 16-register file, and is capable of running programs loaded into its instruction memory. The entire design is modular and synthesized for simulation using Xilinx Vivado.

---

### In-Depth Blog Post

For a comprehensive walkthrough of the design process, architecture, and a detailed explanation of the simulation results, please read my detailed blog post on this project:

[Processor Design in Verilog - Devansh's Blog](https://devansh-lodha.github.io/blog/posts/processor_verilog/processor_verilog.html) 

---

### Architecture Overview

The processor follows a modular design, with distinct Verilog modules for each functional unit.

![Our Processor Architecture](processor_arch.png)

* **Top-Level Module (`processor.v`)**: Integrates all sub-modules and includes the Program Counter (PC) logic.
* **Instruction Memory (`instruction_memory.v`)**: A 32-byte read-only memory that stores the program to be executed. Unused memory is filled with `HLT` instructions to prevent runaway execution.
* **Register File (`register_file.v`)**: Contains 16 general-purpose 8-bit registers. It responds to read/write signals from the Control Unit.
* **ALU (`alu.v`)**: The Arithmetic Logic Unit performs all arithmetic and bitwise operations as dictated by the Control Unit.
* **Accumulator (`accumulator.v`)**: A special-purpose register that acts as an implicit operand and destination for most ALU operations.
* **Control Unit (`control_unit.v`)**: The "brain" of the processor. It decodes instructions and generates all necessary control signals for the other modules.

You can view the processor's schematic here: [`processor_schematic.pdf`](processor_schematic.pdf).

---

### Getting Started: Simulation with Xilinx Vivado

This project is designed to be simulated using **Xilinx Vivado**.

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    ```
2.  Create a new project in Xilinx Vivado.
3.  Add all the Verilog source files (`.v`) to the project as **Design Sources**.
4.  Add the `processor_TB.v` file as a **Simulation Source**.
5.  In the Hierarchy view, set `processor_TB` as the top module for simulation.
6.  Run the Behavioral Simulation to view the waveforms. The included `simulation_results.pdf` shows the expected output for various test programs.

---

### File Directory

Here is a breakdown of the files included in this repository:

| File                    | Description                                                                                                   |
| ----------------------- | ------------------------------------------------------------------------------------------------------------- |
| [`processor.v`](processor.v)         | The top-level module that connects all other components.                                                 |
| [`control_unit.v`](control_unit.v)   | The control unit; decodes instructions and generates control signals.                    |
| [`alu.v`](alu.v)                 | The Arithmetic Logic Unit; performs all calculations.                                     |
| [`register_file.v`](register_file.v) | The 16x8-bit register file for general-purpose data storage.                            |
| [`accumulator.v`](accumulator.v)     | The 8-bit accumulator register.                                                              |
| [`instruction_memory.v`](instruction_memory.v) | The 32-byte memory that stores the program instructions.                             |
| [`processor_TB.v`](processor_TB.v)       | The Verilog testbench used to simulate the processor and verify its functionality.            |
| [`processor_schematic.pdf`](processor_schematic.pdf) | A block diagram showing the processor's architecture and data paths.                                          |
| [`simulation_results.pdf`](simulation_results.pdf)  | A comprehensive report showing the simulation waveforms for various test programs. |

---

### Instruction Set Architecture (ISA)

The processor implements the following 8-bit instruction set. `xxxx` represents a 4-bit register address.

| Opcode       | Instruction | Explanation                                                                                             |
| :----------- | :---------- | :------------------------------------------------------------------------------------------------------ |
| `0000 0000`  | `NOP`       | No operation.                                                                                           |
| `0001 xxxx`  | `ADD Ri`    | Adds the content of Register `i` to the ACC. Updates the C/B register.                          |
| `0010 xxxx`  | `SUB Ri`    | Subtracts the content of Register `i` from the ACC. Updates the C/B register.                 |
| `0011 xxxx`  | `MUL Ri`    | Multiplies the ACC with Register `i`. Stores the result in ACC and EXT.                  |
| `0101 xxxx`  | `AND Ri`    | Performs a bitwise AND between ACC and Register `i`.                                          |
| `0110 xxxx`  | `XRA Ri`    | Performs a bitwise XOR between ACC and Register `i`.                                          |
| `0111 xxxx`  | `CMP Ri`    | Compares ACC with Register `i` (ACC-Reg) and updates C/B.                               |
| `1001 xxxx`  | `MOV ACC, Ri` | Moves the content of Register `i` into the ACC.                                             |
| `1010 xxxx`  | `MOV Ri, ACC` | Moves the content of the ACC into Register `i`.                                               |
| `0000 0001`  | `LSL ACC`   | Logical shift left on the ACC.                                                                |
| `0000 0010`  | `LSR ACC`   | Logical shift right on the ACC.                                                               |
| `0000 0011`  | `CIR ACC`   | Circular shift right on the ACC.                                                              |
| `0000 0100`  | `CIL ACC`   | Circular shift left on the ACC.                                                               |
| `0000 0101`  | `ASR ACC`   | Arithmetic shift right on the ACC.                                                            |
| `0000 0110`  | `INC ACC`   | Increments the ACC. Updates C/B on overflow.                                                  |
| `0000 0111`  | `DEC ACC`   | Decrements the ACC. Updates C/B on underflow.                                                 |
| `1000 xxxx`  | `Br <addr>` | If C/B is 1, the PC jumps to the 4-bit address.                                        |
| `1011 xxxx`  | `Ret <addr>`| The PC jumps to the 4-bit address for returning.                                  |
| `1111 1111`  | `HLT`       | Halts the processor by stopping the PC from incrementing.                                     |

`timescale 1ns / 1ps

module processor (
    input clk,
    input reset,
    output [7:0] pc,
    output [7:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,
    output [7:0] reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15,
    output reg cb_reg
);

    // We will expose the reg values to see the waveform
    assign reg0  = reg_file.regs[0];
    assign reg1  = reg_file.regs[1];
    assign reg2  = reg_file.regs[2];
    assign reg3  = reg_file.regs[3];
    assign reg4  = reg_file.regs[4];
    assign reg5  = reg_file.regs[5];
    assign reg6  = reg_file.regs[6];
    assign reg7  = reg_file.regs[7];
    assign reg8  = reg_file.regs[8];
    assign reg9  = reg_file.regs[9];
    assign reg10 = reg_file.regs[10];
    assign reg11 = reg_file.regs[11];
    assign reg12 = reg_file.regs[12];
    assign reg13 = reg_file.regs[13];
    assign reg14 = reg_file.regs[14];
    assign reg15 = reg_file.regs[15];

    // Program Counter and Instruction Fetch
    wire [7:0] instruction;
    reg [7:0] pc_reg;
    
    // Instruction Memory
    instruction_memory imem (
        .addr(pc_reg),
        .instruction(instruction)
    );

    // Other Components
    wire [7:0] data_bus;
    wire [7:0] acc_value, alu_result, ext_result;
    wire alu_carry;
    reg [7:0] ext_reg;

    // Control Signals
    wire reg_read_en;
    wire [3:0] reg_read_addr;
    wire reg_write_en;
    wire [3:0] reg_write_addr;
    wire acc_sel, acc_write_en, acc_output_en;
    wire [3:0] alu_op;
    wire ext_write_en, cb_write_en;
    wire [7:0] next_pc;

    register_file reg_file (
        .clk(clk),
        .read_addr(reg_read_addr),
        .read_en(reg_read_en),
        .write_addr(reg_write_addr),
        .write_en(reg_write_en),
        .bus(data_bus)
    );

    accumulator acc (
        .clk(clk),
        .alu_in(alu_result),
        .bus_in(data_bus),
        .acc_sel(acc_sel),
        .write_en(acc_write_en),
        .output_en(acc_output_en),
        .acc_value(acc_value),
        .bus_out(data_bus)
    );

    alu alu (
        .acc(acc_value),
        .bus(data_bus),
        .alu_op(alu_op),
        .result(alu_result),
        .carry(alu_carry),
        .ext_result(ext_result)
    );

    control_unit ctrl (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .cb_reg(cb_reg),
        .alu_carry(alu_carry),
        .reg_read_en(reg_read_en),
        .reg_read_addr(reg_read_addr),
        .reg_write_en(reg_write_en),
        .reg_write_addr(reg_write_addr),
        .acc_sel(acc_sel),
        .acc_write_en(acc_write_en),
        .acc_output_en(acc_output_en),
        .alu_op(alu_op),
        .ext_write_en(ext_write_en),
        .cb_write_en(cb_write_en),
        .next_pc(next_pc),
        .current_pc(pc_reg),
        .bus_value(data_bus)
    );

    always @(posedge clk) begin
        if (ext_write_en) ext_reg <= ext_result;
        if (reset) cb_reg <= 0;
        else if (cb_write_en) cb_reg <= alu_carry;
        if (reset) pc_reg <= 0;
        else pc_reg <= next_pc;
    end

    assign pc = pc_reg;
endmodule
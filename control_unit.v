`timescale 1ns / 1ps

module control_unit (
    input clk,
    input reset,
    input [7:0] instruction,
    input cb_reg,
    input alu_carry,
    output reg reg_read_en,
    output reg [3:0] reg_read_addr,
    output reg reg_write_en,
    output reg [3:0] reg_write_addr,
    output reg acc_sel,
    output reg acc_write_en,
    output reg acc_output_en,
    output reg [3:0] alu_op,
    output reg ext_write_en,
    output reg cb_write_en,
    output reg [7:0] next_pc,
    input [7:0] current_pc,
    input [7:0] bus_value
);
    parameter ADD=0, SUB=1, MUL=2, AND=3, XOR=4, SHL=5, SHR=6, CRS=7, CLS=8, ASR=9, INC=10, DEC=11;

    always @(*) begin
        reg_read_en = 0;
        reg_read_addr = 0;
        reg_write_en = 0;
        reg_write_addr = 0;
        acc_sel = 0;
        acc_write_en = 0;
        acc_output_en = 0;
        alu_op = 0;
        ext_write_en = 0;
        cb_write_en = 0;
        next_pc = current_pc + 1;

        casez (instruction)
            8'b0001_zzzz: begin // ADD
                reg_read_en = 1;
                reg_read_addr = instruction[3:0];
                alu_op = ADD;
                acc_sel = 1;
                acc_write_en = 1;
                cb_write_en = 1;
            end
            8'b0010_zzzz: begin // SUB
                reg_read_en = 1;
                reg_read_addr = instruction[3:0];
                alu_op = SUB;
                acc_sel = 1;
                acc_write_en = 1;
                cb_write_en = 1;
            end
            8'b0011_zzzz: begin // MUL
                reg_read_en = 1;
                reg_read_addr = instruction[3:0];
                alu_op = MUL;
                acc_sel = 1;
                acc_write_en = 1;
                ext_write_en = 1;
            end
            8'b0000_0001: begin // LS
                alu_op = SHL;
                acc_sel = 1;
                acc_write_en = 1;
            end
            8'b0000_0010: begin // RS
                alu_op = SHR;
                acc_sel = 1;
                acc_write_en = 1;
            end
            8'b0000_0011: begin // CRS
                alu_op = CRS;
                acc_sel = 1;
                acc_write_en = 1;
            end
            8'b0000_0100: begin // CLS
                alu_op = CLS;
                acc_sel = 1;
                acc_write_en = 1;
            end
            8'b0000_0101: begin // ARS
                alu_op = ASR;
                acc_sel = 1;
                acc_write_en = 1;
            end
            8'b0101_zzzz: begin // AND
                reg_read_en = 1;
                reg_read_addr = instruction[3:0];
                alu_op = AND;
                acc_sel = 1;
                acc_write_en = 1;
            end
            8'b0110_zzzz: begin // XOR
                reg_read_en = 1;
                reg_read_addr = instruction[3:0];
                alu_op = XOR;
                acc_sel = 1;
                acc_write_en = 1;
            end
            8'b0111_zzzz: begin // CMP
                reg_read_en = 1;
                reg_read_addr = instruction[3:0];
                alu_op = SUB;
                cb_write_en = 1; 
            end
            8'b0000_0110: begin // INC
                alu_op = INC;
                acc_sel = 1;
                acc_write_en = 1;
                cb_write_en = alu_carry; // Using carry we can ensure it updates only at overflow
            end
            8'b0000_0111: begin // DEC
                alu_op = DEC;
                acc_sel = 1;
                acc_write_en = 1;
                cb_write_en = alu_carry; // Using carry we can ensure it updates only at underflow
            end
            8'b1000_zzzz: begin // Conditional branch
                if (cb_reg) next_pc = {4'b0, instruction[3:0]};
            end 
            8'b1001_zzzz: begin // MOV Ri to ACC
                reg_read_en = 1;
                reg_read_addr = instruction[3:0];
                acc_write_en = 1;
            end
            8'b1010_zzzz: begin // MOV ACC to Ri
                acc_output_en = 1;
                reg_write_en = 1;
                reg_write_addr = instruction[3:0];
            end
            8'b1011_zzzz: begin // RETURN
                next_pc = {4'b0, instruction[3:0]};
            end
            8'b1111_1111: next_pc = current_pc; // HALT
            default: begin
                next_pc = current_pc + 1;
            end
        endcase
    end
endmodule
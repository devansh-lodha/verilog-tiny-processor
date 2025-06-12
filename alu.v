`timescale 1ns / 1ps

module alu (
    input [7:0] acc,
    input [7:0] bus,
    input [3:0] alu_op,
    output reg [7:0] result,
    output reg carry,
    output reg [7:0] ext_result
);
    parameter ADD=0, SUB=1, MUL=2, AND=3, XOR=4, SHL=5, SHR=6, CRS=7, CLS=8, ASR=9, INC=10, DEC=11;

    always @(*) begin
        {carry, result} = 9'b0;
        ext_result = 8'b0;
        case (alu_op)
            ADD: {carry, result} = acc + bus;
            SUB: {carry, result} = acc - bus;
            MUL: {ext_result, result} = acc * bus;
            AND: result = acc & bus;
            XOR: result = acc ^ bus;
            SHL: result = {acc[6:0], 1'b0};
            SHR: result = {1'b0, acc[7:1]};
            CRS: result = {acc[0], acc[7:1]};          
            CLS: result = {acc[6:0], acc[7]};
            ASR: result = {acc[7], acc[7:1]};
            INC: {carry, result} = {1'b0, acc} + 9'h1; 
            DEC: {carry, result} = {1'b0, acc} - 9'h1;
            default: result = acc;
        endcase
    end
endmodule

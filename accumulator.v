`timescale 1ns / 1ps

module accumulator (
    input clk,
    input [7:0] alu_in,
    input [7:0] bus_in,
    input acc_sel,
    input write_en,
    input output_en,
    output reg [7:0] acc_value,
    inout [7:0] bus_out
);
    wire [7:0] next_acc = acc_sel ? alu_in : bus_in;
    assign bus_out = output_en ? acc_value : 8'bz;

    always @(posedge clk) begin
        if (write_en) acc_value <= next_acc;
    end
endmodule

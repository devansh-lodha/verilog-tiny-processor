`timescale 1ns / 1ps

module register_file (
    input clk,
    input [3:0] read_addr,
    input read_en,
    input [3:0] write_addr,
    input write_en,
    inout [7:0] bus
);
    reg [7:0] regs[0:15];
    
    // Initialize at start of the clock
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            regs[i] = 8'h00 + i; 
        end
    end
    
    wire [7:0] reg_out = read_en ? regs[read_addr] : 8'bz;
    assign bus = reg_out;

    always @(posedge clk) begin
        if (write_en) regs[write_addr] <= bus;
    end
endmodule

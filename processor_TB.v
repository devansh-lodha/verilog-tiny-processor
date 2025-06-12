`timescale 1ns / 1ps

module processor_TB();

    reg clk, reset;
    wire [7:0] pc;
    wire [7:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,
               reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15;
    wire cb_reg;

    processor uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .cb_reg(cb_reg),
        .reg0(reg0),  .reg1(reg1),  .reg2(reg2),  .reg3(reg3),
        .reg4(reg4),  .reg5(reg5),  .reg6(reg6),  .reg7(reg7),
        .reg8(reg8),  .reg9(reg9),  .reg10(reg10),.reg11(reg11),
        .reg12(reg12),.reg13(reg13),.reg14(reg14),.reg15(reg15)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Monitor register values
//    initial begin
//        $monitor("Time=%0t: PC=%h, R0=%h, R1=%h, R15=%h", 
//                 $time, pc, 
//                 uut.reg_file.regs[0], 
//                 uut.reg_file.regs[1],
//                 uut.reg_file.regs[15]);
//    end

    // Test sequence
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0; // Release reset after 10ns

        // Run until HALT (PC stops changing)
        #100 $finish;
    end

endmodule

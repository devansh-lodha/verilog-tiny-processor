module instruction_memory(
    input [7:0] addr,
    output [7:0] instruction
);
    reg [7:0] mem [0:32]; // 32-byte instruction memory
    integer i;
    
    initial begin
        // Load test program (Here we can add any set of instructions)
        mem[0] = 8'b1011_0011; // RET → PC=3
        mem[1] = 8'b1111_1111; // HALT (Unreachable)
        mem[2] = 8'b1111_1111; // HALT (Unreachable)
        mem[3] = 8'b1001_0001; // MOV R1 -> ACC → ACC=1
        mem[4] = 8'b1111_1111; // HALT (Target)




  
        // Here we fill the rest of the memory with HALT because if
        // in case PC jumps to address value other than above then
        // we do not want the program to run indefinitely.
        // This also ensures that the memory it is pointing to is
        // always defined.
        for (i = 5; i < 32; i = i + 1) begin
            mem[i] = 8'b1111_1111;
        end
        
    end
    
    assign instruction = mem[addr];
endmodule
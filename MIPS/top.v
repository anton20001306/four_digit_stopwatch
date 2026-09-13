module top (                         // Top-level MIPS system module
    input        clk,                 // Processor clock
    input        reset,               // Processor reset signal
    output [31:0] writedata,          // Data sent to data memory
    output [31:0] dataaddr,           // Address sent to data memory
    output       memwrite             // Data-memory write enable
);

    wire [31:0] pc;                   // Current program counter
    wire [31:0] instr;                // Instruction from instruction memory
    wire [31:0] readdata;             // Data read from data memory

    mips mips (                       // Instantiate the MIPS processor
        clk,                          // Connect the clock
        reset,                        // Connect the reset
        pc,                           // Connect the program counter
        instr,                        // Connect the fetched instruction
        memwrite,                     // Connect the memory write control
        dataaddr,                     // Connect the ALU memory address
        writedata,                    // Connect the data to be written
        readdata                      // Connect the data read from memory
    );

    imem imem (                       // Instantiate instruction memory
        pc[7:2],                      // Use word address bits from the PC
        instr                         // Return the selected instruction
    );

    dmem dmem (                       // Instantiate data memory
        clk,                          // Connect the memory clock
        memwrite,                     // Connect the write enable
        dataaddr,                     // Connect the memory address
        writedata,                    // Connect the write data
        readdata                      // Connect the read data
    );

endmodule                             // End of the top-level module
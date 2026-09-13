module mips (                         // Main single-cycle MIPS processor
    input        clk,                 // Clock signal
    input        reset,               // Reset signal for the program counter
    output [31:0] pc,                  // Current program counter value
    input  [31:0] instr,              // Instruction from instruction memory
    output       memwrite,             // Write enable for data memory
    output [31:0] aluout,              // ALU result or data-memory address
    output [31:0] writedata,           // Register data sent to data memory
    input  [31:0] readdata             // Data read from data memory
);

    wire memtoreg;                    // Select ALU result or memory data
    wire alusrc;                      // Select register data or immediate
    wire regdst;                      // Select rt or rd as destination
    wire regwrite;                    // Enable register-file write
    wire jump;                        // Select jump target for the PC
    wire pcsrc;                       // Select branch target for the PC
    wire zero;                        // Indicates that the ALU result is zero
    wire [2:0] alucontrol;            // Operation control for the ALU

    controller c (                     // Instantiate the control unit
        instr[31:26],                  // Send the instruction opcode
        instr[5:0],                    // Send the instruction funct field
        zero,                          // Send the ALU zero result
        memtoreg,                      // Receive memory-to-register control
        memwrite,                      // Receive data-memory write control
        pcsrc,                         // Receive branch PC control
        alusrc,                        // Receive ALU-source control
        regdst,                        // Receive register-destination control
        regwrite,                      // Receive register-write control
        jump,                          // Receive jump control
        alucontrol                     // Receive ALU operation control
    );

    datapath dp (                      // Instantiate the datapath
        clk,                           // Connect the clock
        reset,                         // Connect the reset
        memtoreg,                      // Select the register write-back data
        pcsrc,                         // Select the next PC source
        alusrc,                        // Select the second ALU input
        regdst,                        // Select the destination register
        regwrite,                      // Enable register-file writing
        jump,                          // Select the jump target
        alucontrol,                    // Control the ALU operation
        zero,                          // Return whether the ALU result is zero
        pc,                            // Return the current program counter
        instr,                         // Provide the current instruction
        aluout,                        // Return the ALU result
        writedata,                     // Return data for a store instruction
        readdata                       // Provide data loaded from memory
    );

endmodule                             // End of the MIPS processor

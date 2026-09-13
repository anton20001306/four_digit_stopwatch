module regfile (                     // MIPS register-file module
    input        clk,                 // Clock used for register writes
    input        we3,                 // Write-enable signal
    input  [4:0] ra1,                 // Address of the first register to read
    input  [4:0] ra2,                 // Address of the second register to read
    input  [4:0] wa3,                 // Address of the register to write
    input  [31:0] wd3,                // Data to write into the register
    output [31:0] rd1,                // Data read from the first register
    output [31:0] rd2                 // Data read from the second register
);

    reg [31:0] rf [31:0];              // 32 registers, each 32 bits wide

    always @(posedge clk) begin         // Run when the clock rises
        if (we3)                        // Write only when enabled
            rf[wa3] <= wd3;             // Store data in the selected register
    end

    assign rd1 = (ra1 != 0) ? rf[ra1] : 0; // Read port 1; register 0 returns 0
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0; // Read port 2; register 0 returns 0

endmodule                             // End of the register-file module

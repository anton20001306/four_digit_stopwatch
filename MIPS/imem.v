module imem (
    input  [5:0]  a,
    output [31:0] rd
);

    reg [31:0] RAM [63:0];

    // Load the machine-code program into instruction memory.
    initial begin
        $readmemh("MIPS/memfile.dat", RAM);
    end

    // Read the instruction selected by the word address.
    assign rd = RAM[a];

endmodule

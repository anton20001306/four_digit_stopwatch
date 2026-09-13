module datapath (
    input        clk,
    input        reset,
    input        memtoreg,
    input        pcsrc,
    input        alusrc,
    input        regdst,
    input        regwrite,
    input        jump,
    input  [2:0] alucontrol,
    output       zero,
    output [31:0] pc,
    input  [31:0] instr,
    output [31:0] aluout,
    output [31:0] writedata,
    input  [31:0] readdata
);

    wire [4:0]  writereg;
    wire [31:0] pcnext;
    wire [31:0] pcnextbr;
    wire [31:0] pcplus4;
    wire [31:0] pcbranch;
    wire [31:0] signimm;
    wire [31:0] signimmsh;
    wire [31:0] srca;
    wire [31:0] srcb;
    wire [31:0] result;

    // Next-program-counter logic.
    flopr #(32) pcreg(clk, reset, pcnext, pc);
    adder       pcadd1(pc, 32'b100, pcplus4);
    sl2         immshift(signimm, signimmsh);
    adder       pcadd2(pcplus4, signimmsh, pcbranch);
    mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
    mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], instr[25:0], 2'b00}, jump, pcnext);

    // Register-file logic.
    regfile rf(
        clk,
        regwrite,
        instr[25:21],
        instr[20:16],
        writereg,
        result,
        srca,
        writedata
    );
    mux2 #(5)   wrmux(instr[20:16], instr[15:11], regdst, writereg);
    mux2 #(32)  resmux(aluout, readdata, memtoreg, result);
    signext     se(instr[15:0], signimm);

    // ALU logic.
    mux2 #(32)  srcbmux(writedata, signimm, alusrc, srcb);
    alu         aluunit(srca, srcb, alucontrol, aluout, zero);

endmodule

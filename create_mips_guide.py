from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, Preformatted, KeepTogether
)

OUTPUT = "MIPS/mips_interview_guide.pdf"

doc = SimpleDocTemplate(
    OUTPUT,
    pagesize=letter,
    rightMargin=0.55 * inch,
    leftMargin=0.55 * inch,
    topMargin=0.48 * inch,
    bottomMargin=0.45 * inch,
    title="Single-Cycle MIPS Processor Interview Guide",
    author="GitHub Copilot",
)

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(
    name="GuideTitle", parent=styles["Title"], fontName="Helvetica-Bold",
    fontSize=21, leading=24, alignment=TA_CENTER, textColor=colors.HexColor("#12355B"),
    spaceAfter=6,
))
styles.add(ParagraphStyle(
    name="Subtitle", parent=styles["Normal"], fontName="Helvetica",
    fontSize=9.5, leading=12, alignment=TA_CENTER, textColor=colors.HexColor("#444444"),
    spaceAfter=10,
))
styles.add(ParagraphStyle(
    name="H1Guide", parent=styles["Heading1"], fontName="Helvetica-Bold",
    fontSize=14, leading=17, textColor=colors.HexColor("#12355B"), spaceBefore=4, spaceAfter=5,
))
styles.add(ParagraphStyle(
    name="H2Guide", parent=styles["Heading2"], fontName="Helvetica-Bold",
    fontSize=10.5, leading=13, textColor=colors.HexColor("#1E5A83"), spaceBefore=4, spaceAfter=3,
))
styles.add(ParagraphStyle(
    name="BodyGuide", parent=styles["BodyText"], fontName="Helvetica",
    fontSize=8.7, leading=11.2, spaceAfter=4,
))
styles.add(ParagraphStyle(
    name="SmallGuide", parent=styles["BodyText"], fontName="Helvetica",
    fontSize=7.8, leading=9.5, spaceAfter=2,
))
styles.add(ParagraphStyle(
    name="BoxGuide", parent=styles["BodyText"], fontName="Helvetica-Bold",
    fontSize=8.5, leading=10.5, textColor=colors.HexColor("#12355B"),
))
code_style = ParagraphStyle(
    name="CodeGuide", fontName="Courier", fontSize=7.2, leading=8.7,
    leftIndent=4, rightIndent=4, spaceBefore=2, spaceAfter=4,
)


def p(text, style="BodyGuide"):
    return Paragraph(text, styles[style])


def code(text):
    return Preformatted(text.strip("\n"), code_style)


def table(data, widths, header=True, font=7.2):
    t = Table(data, colWidths=widths, repeatRows=1 if header else 0)
    commands = [
        ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#AAB7C4")),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 4),
        ("RIGHTPADDING", (0, 0), (-1, -1), 4),
        ("TOPPADDING", (0, 0), (-1, -1), 3),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
        ("FONTSIZE", (0, 0), (-1, -1), font),
    ]
    if header:
        commands += [
            ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#DCEAF5")),
            ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
            ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#12355B")),
        ]
    t.setStyle(TableStyle(commands))
    return t


def footer(canvas, doc):
    canvas.saveState()
    canvas.setStrokeColor(colors.HexColor("#B8C5D1"))
    canvas.line(doc.leftMargin, 0.32 * inch, letter[0] - doc.rightMargin, 0.32 * inch)
    canvas.setFont("Helvetica", 7)
    canvas.setFillColor(colors.HexColor("#65727E"))
    canvas.drawString(doc.leftMargin, 0.18 * inch, "Single-cycle MIPS interview guide")
    canvas.drawRightString(letter[0] - doc.rightMargin, 0.18 * inch, "Page %d" % doc.page)
    canvas.restoreState()


story = []

# PAGE 1
story += [
    p("Single-Cycle MIPS Processor", "GuideTitle"),
    p("Three-page interview guide based on the modules in your MIPS project", "Subtitle"),
    p("1. Big Picture: What You Built", "H1Guide"),
    p("You built a small 32-bit single-cycle MIPS processor. Every instruction completes in one clock cycle. The processor is split into a control unit, a datapath, instruction memory, and data memory.", "BodyGuide"),
    table([
        [p("Block", "BoxGuide"), p("Job", "BoxGuide"), p("Your file", "BoxGuide")],
        [p("top", "SmallGuide"), p("Connects the processor and both memories", "SmallGuide"), p("top.v", "SmallGuide")],
        [p("mips", "SmallGuide"), p("Combines controller and datapath", "SmallGuide"), p("mips.v", "SmallGuide")],
        [p("controller", "SmallGuide"), p("Translates instruction fields into control signals", "SmallGuide"), p("controller.v", "SmallGuide")],
        [p("datapath", "SmallGuide"), p("Moves data, calculates addresses, and updates PC", "SmallGuide"), p("datapath.v", "SmallGuide")],
        [p("imem", "SmallGuide"), p("Returns the instruction selected by PC", "SmallGuide"), p("imem.v", "SmallGuide")],
        [p("dmem", "SmallGuide"), p("Reads and writes program data", "SmallGuide"), p("dmem.v", "SmallGuide")],
    ], [1.0 * inch, 3.25 * inch, 1.45 * inch]),
    Spacer(1, 5),
    p("Top-level data flow", "H2Guide"),
    code("PC -> imem -> instr -> mips\nmips -> dataaddr, writedata, memwrite -> dmem\ndmem -> readdata -> mips"),
    p("The PC is an address, not an instruction. The processor generates the PC. Instruction memory uses it to choose a 32-bit instruction and returns that instruction on instr.", "BodyGuide"),
    p("2. What Happens During One Cycle", "H1Guide"),
    table([
        [p("Step", "BoxGuide"), p("Hardware action", "BoxGuide")],
        [p("1. Fetch", "SmallGuide"), p("PC selects an instruction in imem. The instruction is returned as instr.", "SmallGuide")],
        [p("2. Decode", "SmallGuide"), p("The controller reads opcode instr[31:26] and funct instr[5:0]. The register file reads rs and rt.", "SmallGuide")],
        [p("3. Execute", "SmallGuide"), p("The ALU performs add, subtract, AND, OR, or SLT.", "SmallGuide")],
        [p("4. Memory", "SmallGuide"), p("lw reads dmem; sw writes dmem; other instructions do not access data memory.", "SmallGuide")],
        [p("5. Write-back", "SmallGuide"), p("The ALU result or loaded memory data is written to one register when regwrite is 1.", "SmallGuide")],
        [p("6. Next PC", "SmallGuide"), p("The PC register captures pcnext on the rising clock edge.", "SmallGuide")],
    ], [1.0 * inch, 4.7 * inch]),
    Spacer(1, 4),
    p("Important address detail", "H2Guide"),
    p("MIPS instructions are 4 bytes, so PC values normally increase by 4. imem receives pc[7:2], which removes the two byte-offset bits: PC 0 selects instruction 0, PC 4 selects instruction 1, and PC 8 selects instruction 2.", "BodyGuide"),
    PageBreak(),
]

# PAGE 2
story += [
    p("3. Datapath and Control Signals", "H1Guide"),
    p("The controller makes decisions; the datapath performs the operations. The following signals are the central interview vocabulary.", "BodyGuide"),
    table([
        [p("Signal", "BoxGuide"), p("Meaning", "BoxGuide")],
        [p("regwrite", "SmallGuide"), p("1 writes a result into the register file.", "SmallGuide")],
        [p("regdst", "SmallGuide"), p("0 chooses rt as destination; 1 chooses rd.", "SmallGuide")],
        [p("alusrc", "SmallGuide"), p("0 selects the second register value; 1 selects the sign-extended immediate.", "SmallGuide")],
        [p("memtoreg", "SmallGuide"), p("0 writes the ALU result; 1 writes data read from dmem.", "SmallGuide")],
        [p("memwrite", "SmallGuide"), p("1 enables a data-memory write for sw.", "SmallGuide")],
        [p("branch", "SmallGuide"), p("1 says the instruction is a conditional branch.", "SmallGuide")],
        [p("pcsrc", "SmallGuide"), p("branch & zero; selects the branch target when beq is true.", "SmallGuide")],
        [p("jump", "SmallGuide"), p("Selects the jump target instead of the sequential or branch PC.", "SmallGuide")],
        [p("aluop", "SmallGuide"), p("Broad ALU category: 00 add, 01 subtract, 10 inspect funct.", "SmallGuide")],
        [p("alucontrol", "SmallGuide"), p("Exact ALU command: 000 AND, 001 OR, 010 ADD, 110 SUB, 111 SLT.", "SmallGuide")],
        [p("zero", "SmallGuide"), p("ALU result is zero; used by beq equality checking.", "SmallGuide")],
    ], [1.15 * inch, 4.55 * inch]),
    Spacer(1, 5),
    p("4. Instruction Types", "H1Guide"),
    table([
        [p("Instruction", "BoxGuide"), p("ALU work", "BoxGuide"), p("Key controls", "BoxGuide")],
        [p("R-type: add, sub, and, or, slt", "SmallGuide"), p("Two register operands", "SmallGuide"), p("regwrite=1, regdst=1, alusrc=0, aluop=10", "SmallGuide")],
        [p("lw", "SmallGuide"), p("Base register + immediate address", "SmallGuide"), p("alusrc=1, memtoreg=1, regwrite=1, aluop=00", "SmallGuide")],
        [p("sw", "SmallGuide"), p("Base register + immediate address", "SmallGuide"), p("alusrc=1, memwrite=1, regwrite=0, aluop=00", "SmallGuide")],
        [p("beq", "SmallGuide"), p("Subtract registers to compare", "SmallGuide"), p("branch=1, aluop=01; take if zero=1", "SmallGuide")],
        [p("addi", "SmallGuide"), p("Register + sign-extended immediate", "SmallGuide"), p("alusrc=1, regwrite=1, regdst=0, aluop=00", "SmallGuide")],
        [p("j", "SmallGuide"), p("No ALU data operation required", "SmallGuide"), p("jump=1", "SmallGuide")],
    ], [1.7 * inch, 2.2 * inch, 1.8 * inch]),
    Spacer(1, 5),
    p("5. PC Selection", "H1Guide"),
    code("pcplus4  = pc + 4\npcbranch = pcplus4 + (signimm << 2)\npcnextbr = pcsrc ? pcbranch : pcplus4\npcnext   = jump ? jump_target : pcnextbr"),
    p("For beq, the ALU subtracts the two register values. If the result is zero, zero=1. Since pcsrc=branch & zero, only a true beq condition selects the branch target.", "BodyGuide"),
    PageBreak(),
]

# PAGE 3
story += [
    p("6. Follow One Real Program", "H1Guide"),
    p("Your memfile.dat contains hexadecimal machine instructions. imem loads them with $readmemh. One line is one 32-bit instruction.", "BodyGuide"),
    code("20020005     addi $2,  $0, 5\n2003000c     addi $3,  $0, 12\n2067fff7     addi $7,  $3, -9\n00e22025     or   $4,  $7, $2\n00642824     and  $5,  $3, $4\n00a42820     add  $5,  $5, $4\nac670044     sw   $7,  68($3)\n8c020050     lw   $2,  80($0)\nac020054     sw   $2,  84($0)"),
    p("The final store succeeds because register $2 receives 7 from memory address 80, then sw calculates 0 + 84 and writes that value to address 84.", "BodyGuide"),
    code("$3 = 12\n$7 = 12 + (-9) = 3\n$4 = $7 OR $2 = 3 OR 5 = 7\nstore at 80 receives 7\nload from 80 gives $2 = 7\nstore at 84 writes 7"),
    p("7. Interview Answers You Can Use", "H1Guide"),
    table([
        [p("Question", "BoxGuide"), p("Short answer", "BoxGuide")],
        [p("Why single-cycle?", "SmallGuide"), p("It is simple to understand: one instruction completes per clock cycle, although the clock must be long enough for the slowest instruction.", "SmallGuide")],
        [p("Why two register reads?", "SmallGuide"), p("R-type and beq instructions need two operands at once. There is one write port because an instruction normally writes one destination.", "SmallGuide")],
        [p("What does aluop do?", "SmallGuide"), p("It gives the ALU decoder a broad category. lw/sw need add, beq needs subtract, and R-type uses funct for the exact operation.", "SmallGuide")],
        [p("What is pcsrc?", "SmallGuide"), p("It selects the next PC source. pcsrc=0 uses PC+4; pcsrc=1 uses the branch target.", "SmallGuide")],
        [p("Why shift branch immediate by 2?", "SmallGuide"), p("The immediate counts instructions, while addresses count bytes. Multiplying by 4 converts instruction offset to byte offset.", "SmallGuide")],
        [p("What is register zero?", "SmallGuide"), p("Register 0 always reads as zero. It is useful for constants and base addresses, such as sw $2,84($0).", "SmallGuide")],
    ], [1.45 * inch, 4.25 * inch]),
    Spacer(1, 5),
    p("8. How to Demonstrate It", "H1Guide"),
    code("cd /home/anton/four_digit_stopwatch\nmake clean\nmake run"),
    p("Expected output:", "H2Guide"),
    code("Simulation succeeded"),
    p("If asked about verification, explain that testbench.v drives clock and reset, imem loads memfile.dat, and the testbench watches dataaddr, writedata, and memwrite. It declares success when the processor performs the expected store of 7 to address 84.", "BodyGuide"),
    p("One honest limitation to mention: a single-cycle design is educational and clear, but it is slower than a pipelined design because every instruction uses one long clock period.", "BodyGuide"),
    PageBreak(),
]

# PAGE 4
story += [
    p("9. Complete Test Program: Assembly to Machine Code", "H1Guide"),
    p("The address column is the byte address of the instruction. The machine column is the 32-bit hexadecimal value loaded into imem. Because each instruction is 4 bytes, addresses increase by 4.", "BodyGuide"),
    table([
        [p("Label", "BoxGuide"), p("Assembly", "BoxGuide"), p("Meaning", "BoxGuide"), p("Address", "BoxGuide"), p("Machine code", "BoxGuide")],
        [p("main", "SmallGuide"), p("addi $2,$0,5", "SmallGuide"), p("initialize $2 = 5", "SmallGuide"), p("0", "SmallGuide"), p("20020005", "SmallGuide")],
        [p("", "SmallGuide"), p("addi $3,$0,12", "SmallGuide"), p("initialize $3 = 12", "SmallGuide"), p("4", "SmallGuide"), p("2003000c", "SmallGuide")],
        [p("", "SmallGuide"), p("addi $7,$3,-9", "SmallGuide"), p("$7 = 12 - 9 = 3", "SmallGuide"), p("8", "SmallGuide"), p("2067fff7", "SmallGuide")],
        [p("", "SmallGuide"), p("or $4,$7,$2", "SmallGuide"), p("$4 = 3 OR 5 = 7", "SmallGuide"), p("12", "SmallGuide"), p("00e22025", "SmallGuide")],
        [p("", "SmallGuide"), p("and $5,$3,$4", "SmallGuide"), p("$5 = 12 AND 7 = 4", "SmallGuide"), p("16", "SmallGuide"), p("00642824", "SmallGuide")],
        [p("", "SmallGuide"), p("add $5,$5,$4", "SmallGuide"), p("$5 = 4 + 7 = 11", "SmallGuide"), p("20", "SmallGuide"), p("00a42820", "SmallGuide")],
        [p("", "SmallGuide"), p("beq $5,$7,end", "SmallGuide"), p("11 != 3, branch not taken", "SmallGuide"), p("24", "SmallGuide"), p("10a7000a", "SmallGuide")],
        [p("", "SmallGuide"), p("slt $4,$3,$4", "SmallGuide"), p("12 < 7 is false, $4 = 0", "SmallGuide"), p("28", "SmallGuide"), p("0084202a", "SmallGuide")],
        [p("", "SmallGuide"), p("beq $4,$0,around", "SmallGuide"), p("0 == 0, branch taken", "SmallGuide"), p("32", "SmallGuide"), p("10800001", "SmallGuide")],
        [p("", "SmallGuide"), p("addi $5,$0,0", "SmallGuide"), p("skipped by branch", "SmallGuide"), p("36", "SmallGuide"), p("20050000", "SmallGuide")],
        [p("around", "SmallGuide"), p("slt $4,$7,$2", "SmallGuide"), p("3 < 5 is true, $4 = 1", "SmallGuide"), p("40", "SmallGuide"), p("00e2202a", "SmallGuide")],
        [p("", "SmallGuide"), p("add $7,$4,$5", "SmallGuide"), p("$7 = 1 + 11 = 12", "SmallGuide"), p("44", "SmallGuide"), p("00853820", "SmallGuide")],
        [p("", "SmallGuide"), p("sub $7,$7,$2", "SmallGuide"), p("$7 = 12 - 5 = 7", "SmallGuide"), p("48", "SmallGuide"), p("00e23822", "SmallGuide")],
        [p("", "SmallGuide"), p("sw $7,68($3)", "SmallGuide"), p("memory[80] = 7", "SmallGuide"), p("52", "SmallGuide"), p("ac670044", "SmallGuide")],
        [p("", "SmallGuide"), p("lw $2,80($0)", "SmallGuide"), p("$2 = memory[80] = 7", "SmallGuide"), p("56", "SmallGuide"), p("8c020050", "SmallGuide")],
        [p("", "SmallGuide"), p("j end", "SmallGuide"), p("jump over addi", "SmallGuide"), p("60", "SmallGuide"), p("08000011", "SmallGuide")],
        [p("", "SmallGuide"), p("addi $2,$0,1", "SmallGuide"), p("skipped by jump", "SmallGuide"), p("64", "SmallGuide"), p("20020001", "SmallGuide")],
        [p("end", "SmallGuide"), p("sw $2,84($0)", "SmallGuide"), p("final store", "SmallGuide"), p("68", "SmallGuide"), p("ac020054", "SmallGuide")],
    ], [0.55 * inch, 1.22 * inch, 2.28 * inch, 0.55 * inch, 1.25 * inch], font=6.3),
    Spacer(1, 5),
    p("Note", "H2Guide"),
    p("The corrected project memfile.dat uses 00853820 for add $7,$4,$5 and 10000001 for the unconditional beq $0,$0,around. Those values must match the assembly program used by the testbench.", "BodyGuide"),
    PageBreak(),
]

# PAGE 5
story += [
    p("10. How to Verify the Processor", "H1Guide"),
    p("Verification means proving that the hardware produces the expected behavior, not merely proving that the Verilog compiles.", "BodyGuide"),
    p("Step 1: Compile all RTL", "H2Guide"),
    code("cd /home/anton/four_digit_stopwatch\nmake clean\nmake compile"),
    p("Compilation checks syntax and creates the work library. Every referenced module must be included in RTL_SRCS or compiled by the wildcard command.", "BodyGuide"),
    p("Step 2: Run the automated testbench", "H2Guide"),
    code("make run"),
    p("The testbench drives reset and clock. imem loads memfile.dat. The testbench watches memwrite, dataaddr, and writedata. It prints Simulation succeeded when a store writes 7 to address 84.", "BodyGuide"),
    p("Step 3: Understand the expected final transaction", "H2Guide"),
    table([
        [p("Signal", "BoxGuide"), p("Expected value", "BoxGuide"), p("Reason", "BoxGuide")],
        [p("memwrite", "SmallGuide"), p("1", "SmallGuide"), p("The instruction is sw.", "SmallGuide")],
        [p("dataaddr", "SmallGuide"), p("84", "SmallGuide"), p("$0 + immediate 84 = 84.", "SmallGuide")],
        [p("writedata", "SmallGuide"), p("7", "SmallGuide"), p("$2 was loaded from memory location 80.", "SmallGuide")],
        [p("dmem index", "SmallGuide"), p("21", "SmallGuide"), p("Word index is address[31:2] = 84 / 4.", "SmallGuide")],
    ], [1.1 * inch, 1.15 * inch, 3.15 * inch]),
    p("Step 4: Verify interactively with Questa", "H2Guide"),
    code("vlog -sv MIPS/*.v\nvsim -gui -voptargs=\"+acc\" work.testbench\nadd wave -r /*\nrun -all"),
    p("In the waveform, inspect pc, instr, dataaddr, writedata, memwrite, and the register-file values. At the successful final store, pc is 68, instr is ac020054, memwrite is 1, dataaddr is 84, and writedata is 7.", "BodyGuide"),
    p("Step 5: Verify the memory update", "H2Guide"),
    code("vsim -c -voptargs=+acc work.testbench\nrun 175ns\nexamine -radix decimal /testbench/dut/dataaddr\nexamine -radix decimal /testbench/dut/writedata\nexamine /testbench/dut/memwrite\nexamine -radix decimal /testbench/dut/dmem/RAM(21)"),
    p("RAM[21] corresponds to byte address 84. After the final rising edge, it should contain 7. This is the strongest direct check that dmem received and stored the correct transaction.", "BodyGuide"),
    p("Interview summary", "H2Guide"),
    p("Say: I implemented and verified a 32-bit educational single-cycle MIPS processor. The PC fetches instructions from imem, the controller decodes the opcode and funct fields, the datapath executes the operation, dmem handles loads and stores, and a self-checking testbench confirms the final store transaction.", "BodyGuide"),
]

doc.build(story, onFirstPage=footer, onLaterPages=footer)
print(OUTPUT)

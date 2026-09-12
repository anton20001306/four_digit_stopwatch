`timescale 1ps/1ps  // time_unit/time_precision

module bit_pattern_tb;

logic clk_i, rstn_i, bit_i, match_o;
logic [8 - 1 : 0] test_sequence;


// design usnder test
mealy dut(
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .bit_i(bit_i),
    .match_o(match_o)
);

// clock generation
initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
end

// test bench simulation
initial begin
    $dumpfile("bit_pattern_tb.vcd");
    $dumpvars(0, dut);

    rstn_i = 0;
    bit_i = 0;
    #100 rstn_i = 1;

    // define test sequence
    test_sequence = 8'b01010110;

    // apply test sequence
    for(int i = 0; i < $size(test_sequence); i++) begin
        bit_i = test_sequence[$size(test_sequence) - 1 - i];
        @(posedge clk_i);
        #1;
    end

    @(posedge clk_i);

    // stop simulation
    $stop;
end

endmodule


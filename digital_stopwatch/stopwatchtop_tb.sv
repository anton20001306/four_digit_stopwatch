`timescale 1ns / 1ps

module stopwatchtop_tb;

    logic clk = 1'b0;
    logic rstn = 1'b0;
    logic start = 1'b0;
    logic stop = 1'b0;
    logic increment = 1'b0;
    logic clear = 1'b0;
    logic [7:0] segment;
    logic [3:0] anode;

    stopwatchtop dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .stop(stop),
        .increment(increment),
        .clear(clear),
        .segment(segment),
        .anode(anode)
    );

    // 100 MHz input clock: 10 ns period.
    always #5 clk = ~clk;

    task automatic check_count(input logic [15:0] expected, input string label);
        if (dut.counter_value !== expected) begin
            $error("%s: expected %h, got %h", label, expected, dut.counter_value);
        end
        else begin
            $display("PASS: %s -> %h", label, dut.counter_value);
        end
    endtask

    task automatic press_increment;
        @(negedge dut.clk_1khz);
        increment = 1'b1;
        @(negedge dut.clk_1khz);
        @(negedge dut.clk_1khz);
        increment = 1'b0;
        @(negedge dut.clk_1khz);
    endtask

    initial begin
        repeat (2) @(posedge clk);
        rstn = 1'b1;
        @(negedge dut.clk_1khz);
        check_count(16'h0000, "reset");

        // A held increment button must produce one increment only.
        increment = 1'b1;
        repeat (5) @(negedge dut.clk_1khz);
        increment = 1'b0;
        @(negedge dut.clk_1khz);
        check_count(16'h0001, "held increment");

        // Start and verify two 1 ms stopwatch ticks.
        @(negedge dut.clk_1khz);
        start = 1'b1;
        @(negedge dut.clk_1khz);
        start = 1'b0;
        repeat (3) @(negedge dut.clk_1khz);
        check_count(16'h0004, "start and three ticks");

        // Stop and verify that the displayed value holds.
        @(negedge dut.clk_1khz);
        stop = 1'b1;
        @(negedge dut.clk_1khz);
        stop = 1'b0;
        repeat (2) @(negedge dut.clk_1khz);
        check_count(16'h0005, "stop");

        press_increment();
        check_count(16'h0006, "single increment after stop");

        clear = 1'b1;
        repeat (2) @(negedge dut.clk_1khz);
        clear = 1'b0;
        @(negedge dut.clk_1khz);
        check_count(16'h0000, "clear");

        $display("Stopwatch testbench completed.");
        $finish;
    end

endmodule

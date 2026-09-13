module testbench;

    reg        clk;
    reg        reset;
    wire [31:0] writedata;
    wire [31:0] dataaddr;
    wire        memwrite;

    // Instantiate the processor system under test.
    top dut(clk, reset, writedata, dataaddr, memwrite);

    // Initialize the processor with reset asserted.
    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    // Generate a 10-time-unit clock period.
    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end

    // Check the final store operation from the test program.
    always @(negedge clk) begin
        if (memwrite) begin
            if (dataaddr === 84 && writedata === 7) begin
                $display("Simulation succeeded");
                $stop;
            end
            else if (dataaddr !== 80) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end

endmodule

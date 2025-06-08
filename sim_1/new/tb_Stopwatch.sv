module tb_Stopwatch;

    // Testbench signals
    logic clk;
    logic rstn;
    logic start;
    logic stop;
    logic increment;
    logic clear;
    logic [7:0] segment;
    logic [3:0] anode;

    // Instantiate the Stopwatch module
    Stopwatch uut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .stop(stop),
        .increment(increment),
        .clear(clear),
        .segment(segment),
        .anode(anode)
    );

    // Clock Generation (50MHz clock)
    always begin
        #10 clk = ~clk;  // Toggle clock every 10ns
    end

    // Initial Block to provide stimulus to the design
    initial begin
        // Initialize inputs
        clk = 0;
        rstn = 0;
        start = 0;
        stop = 0;
        increment = 0;
        clear = 0;

        // Apply reset
        $display("Applying reset...");
        #20 rstn = 1;  // Release reset after 20ns
        
        // Start the stopwatch
        $display("Starting stopwatch...");
        #30 start = 1;  // Start the stopwatch after 30ns
        #20 start = 0;  // Stop the start signal after 20ns
        
        // Wait for some time
        #100;
        
        // Increment the stopwatch
        $display("Incrementing stopwatch...");
        increment = 1;
        #20 increment = 0; // Pulse increment for one clock cycle
        
        // Wait for some more time
        #100;
        
        // Clear the stopwatch
        $display("Clearing stopwatch...");
        clear = 1;
        #20 clear = 0;  // Pulse clear for one clock cycle
        
        // Wait for some more time
        #100;

        // Stop the stopwatch
        $display("Stopping stopwatch...");
        stop = 1;
        #20 stop = 0;  // Stop the stopwatch
        
        // Finish simulation after some time
        #100;
        $stop;  // Stop the simulation
    end

    // Monitor the outputs
    initial begin
        $monitor("Time: %0t | Segment: %b | Anode: %b", $time, segment, anode);
    end

endmodule

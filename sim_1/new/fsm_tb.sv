`timescale 1ns / 1ps

module fsm_tb();

    // Inputs
    logic clk = 0;
    logic rstn = 0;
    logic start = 0, stop = 0, increment = 0, clear = 0;

    // Outputs
    logic cen, increment_once, clear_count;

    // Clock generation
    localparam CLK_PERIOD = 100; // smaller value for faster simulation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Instantiate the FSM (DUT = Device Under Test)
    fsm dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .stop(stop),
        .increment(increment),
        .clear(clear),
        .cen(cen),
        .increment_once(increment_once),
        .clear_count(clear_count)
    );

    initial begin   
        
        $dumpfile("dump.vcd");
        $dumpvars(0, dut);

       
        @(posedge clk); rstn <= 1'b1;    
        @(posedge clk); rstn <= 1'b0;    

        @(posedge clk); start <= 1'b1;  
        @(posedge clk); start <= 1'b0; 

        repeat (5) @(posedge clk);

        stop <= 1'b1;   
        @(posedge clk); stop <= 1'b0;   

        repeat (3) @(posedge clk);

        increment <= 1'b1; 
        @(posedge clk); increment <= 1'b0;  

        repeat (3) @(posedge clk);

        clear <= 1'b1;  
        @(posedge clk); clear <= 1'b0;  

        repeat (5) @(posedge clk);

        $finish();
    end

endmodule

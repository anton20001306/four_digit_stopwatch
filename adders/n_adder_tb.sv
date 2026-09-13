`timescale 1ns/1ps

module n_adder_tb;

localparam N = 8;   // number of bits in the adder

logic signed [N - 1:0] A,B,S;
logic ci, co;

n_adder #(.N(N)) dut(.*);

initial begin
    $dumpfile("n_adder_tb.vcd");
    $dumpvars(0, dut);
end

initial begin 
    
    // assertion tests
    #10 A <= 8'd6; B <= -8'sd8; ci <= 1'b0;
    #1 assert(S == -8'sd2 && co == 1'b0)
        #1 $display("Ok: 6 - 8 + 0 = %d, co = %b", S, co);
        else
        $error("Fatal: 6 - 8 + 0 = %d, co = %b", S, co);

    // constriant random tests
    repeat(10) begin
        #9
        A = $urandom_range(-128, 127);
        B = $urandom_range(-128, 127);
        ci = $urandom_range(0, 1);

        // std::randomize(ci);
        // std::randomize(A) with {A inside {[-128:127]};};
        // std::randomize(B) with {B inside {[-128:127]};};
    

        #5 assert({co, S} == A + B + ci)
            #1 $display("Ok: %d + %d + %b = %d, co = %b", A, B, ci, $signed(S), co);
            else
            $error("Fatal: %d + %d + %b = %d, co = %b", A, B, ci, $signed(S), co);
    end 
end

endmodule

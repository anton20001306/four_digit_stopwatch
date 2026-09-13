module full_adder (
    input logic A, B, ci,
    output logic S, co
);
    
assign {S, co} = A + B + ci;

endmodule
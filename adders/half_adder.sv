module half_adder (
    input logic a, b,
    output logic sum, carry
);
    
assign {sum, carry} = a + b;

endmodule
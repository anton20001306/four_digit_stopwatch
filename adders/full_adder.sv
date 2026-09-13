module full_adder (
    input logic a, b, cin,
    output logic sum, cout
);
    
assign {sum, cout} = a + b + cin;

endmodule
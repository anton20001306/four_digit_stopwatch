module sl2 (
    input  [31:0] a,
    output [31:0] y
);

    // Shift left by two bits, equivalent to multiplying by four.
    assign y = {a[29:0], 2'b00};

endmodule

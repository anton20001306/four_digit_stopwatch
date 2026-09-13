module signext (
    input  [15:0] a,
    output [31:0] y
);

    // Copy the sign bit into the upper 16 bits.
    assign y = {{16{a[15]}}, a};

endmodule

module mux2 #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] d0,
    input  [WIDTH-1:0] d1,
    input              s,
    output [WIDTH-1:0] y
);

    // Select d1 when s is 1; otherwise select d0.
    assign y = s ? d1 : d0;

endmodule

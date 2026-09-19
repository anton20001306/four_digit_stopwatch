module alu #(
    parameter WIDTH =  8,

)
(
    input logic signed [WIDTH-1:0] bus_a, 
    input logic signed [WIDTH-1:0] bus_b, 
    input logic [2 : 0] alu_sel,
    output logic signed [WIDTH:0] alu_out,
    output logic zero,
    output logic negative
);

always_comb begin 
    unique case(alu_sel)
        3'b001: alu_out = bus_a + bus_b;
        3'b010: alu_out = bus_a - bus_b;
        3'b011: alu_out = bus_a * bus_b;
        3'b100: alu_out = bus_a % 2;
        default: alu_
end
    
assign zero = alu_out == 0;
assign negative = alu_out[WIDTH - 1] == 1'b1;

endmodule
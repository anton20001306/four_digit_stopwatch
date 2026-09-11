module accumulator#(
    parameter int unsigned WIDTH = 8
) 
(
    input  logic                clk_i,
    input  logic                rstn_i,
    input  logic                en_i,       // enble signal to accumulate data
    input  logic [WIDTH-1:0]    data_i,
    output logic [WIDTH-1:0]    acc_o,
    output logic                overflow_o
);
  
logic [WIDTH : 0] acc_reg;

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if (!rstn_i) begin
        acc_o <= '0;
    end else if (en_i) begin
        acc_o <= acc_reg[WIDTH-1:0];
    end
end

assign acc_reg = {1'b0, acc_o} + {1'b0, data_i};
assign overflow_o = en_i && acc_reg[WIDTH];         // gate
endmodule
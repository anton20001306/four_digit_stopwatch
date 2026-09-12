module mealy(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic bit_i,
    output logic match_o
);

localparam int unsigned n_state = $clog2(3);

// states
enum logic [n_state - 1 : 0]{
    F0 = 2'b00,
    F1 = 2'b01,
    F2 = 2'b10
} state, next_state;

// next state combinational logic
always_comb begin 
    if(state == F0) begin
        if(bit_i == 0) next_state = F0;
        else next_state = F1;
    end
    else if(state == F1) begin
        if(bit_i == 0) next_state = F2;
        else next_state = F1;
    end
    else if(state == F2) begin
        if(bit_i == 0) next_state = F0;
        else next_state = F1;
    end
    else begin
        next_state = F0;
    end
end

// state sequnecer
always_ff @(posedge clk_i or negedge rstn_i) begin
    if(!rstn_i) state <= F0;
    else state <= next_state;
end

// output combinational logic
always_comb begin
    if(state == F2 && bit_i == 1) match_o = 1;
    else match_o = 0;
end
endmodule
module trafficlight(
    input  logic clk_i,
    input  logic rst_i,
    output logic red_o,
    output logic yellow_o,
    output logic green_o
);

enum logic [1:0] {
    RED,
    YELLOW,
    GREEN
} state, next_state;

// next state logic
always_comb begin
    if(state == RED) begin
        next_state = YELLOW;
    end
    else if(state == YELLOW) begin
        next_state = GREEN;
    end
    else if(state == GREEN) begin
        next_state = RED;
    end
    else begin
        next_state = RED;
    end
end

// state logic
always_ff @( posedge clk_i or posedge rst_i ) begin
    if(rst_i) begin
        state <= RED;
    end
    else begin
        state <= next_state;
    end
end

// output logic
always_comb begin

    red_o = 1'b0;
    yellow_o = 1'b0;
    green_o = 1'b0;

    if(state == RED) red_o = 1'b1;
    else if(state == YELLOW) yellow_o = 1'b1;
    else if(state == GREEN) green_o = 1'b1;

end
endmodule
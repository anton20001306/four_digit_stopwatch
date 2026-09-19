module trafficlights (
    
    input  logic clk_i,
    input  logic rst_i,
    output logic red_o, yellow_o, green_o

);

enum logic [1:0]{
    RED,
    YELLOW,
    GREEN
}state, next_state;

// state logic
always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        state <= RED;
    end
    else begin
        state <= next_state;
    end
end

// combinational next state and output
always_comb begin 
    // avoid unintentional latch
    next_state = state;
    red_o = 1'b0;
    green_o = 1'b0;
    yellow_o = 1'b0;

    case(state)
        RED: begin
            next_state = GREEN;
            red_o = 1'b1; 
        end
        GREEN: begin
            next_state = YELLOW;
            green_o = 1'b1;
        end
        YELLOW: begin
            next_state = RED;
            yellow_o = 1'b1;
        end
    default:begin
            next_state = RED;
        end
    endcase

end
endmodule
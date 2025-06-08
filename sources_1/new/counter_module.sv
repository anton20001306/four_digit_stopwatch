
module counter_module #(parameter N = 10)(

    input logic clk,rstn,cen,increment_once, clear_count,
    output logic [15:0] counter_value
    );
    
    logic tc0,tc1,tc2;
    logic cen1, cen2, cen3;
    
    param_mod_counter #(10) u0(
        .clk(clk),
        .rstn(rstn),
        .cen(cen | increment_once),
        .count(counter_value[3:0]),
        .TC_1001(tc0));
        
    param_mod_counter #(10) u1(
        .clk(clk),
        .rstn(rstn),
        .cen(tc0),
        .count(counter_value[7:4]),
        .TC_1001(tc1));
        
    param_mod_counter #(10) u2(
        .clk(clk),
        .rstn(rstn),
        .cen(tc1),
        .count(counter_value[11:8]),
        .TC_1001(tc2));
        
    param_mod_counter #(10) u3(
        .clk(clk),
        .rstn(rstn),
        .cen(tc2),
        .count(counter_value[15:12]),
        .TC_1001());
        
   always_ff @(posedge clk or negedge rstn) begin
        if(!rstn || clear_count) begin
            counter_value <= 16'd0;
            end
            end   
    
        
    
endmodule

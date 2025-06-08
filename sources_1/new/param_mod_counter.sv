

module param_mod_counter #(parameter N = 10)(
    
    input logic clk, rstn, cen,
    output logic [$clog2(N)-1:0] count,
    output logic TC_1001
    );
    
    always_ff @(posedge clk or negedge rstn) begin
        
        if(!rstn) begin
            count <= 0;
            TC_1001 <=1'b0;
        end         
        else if(cen) begin
            if(count == N-1) begin
                count <= 0;
                TC_1001 <= 1'b1; 
            end
            else begin
                count <= count + 1'b1;
                TC_1001 <= 1'b0;
            end
        end
        else begin
            TC_1001 <= 1'b0;
        end
         
    end
    
endmodule

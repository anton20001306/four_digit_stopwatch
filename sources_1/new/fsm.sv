
module fsm(
    input logic start,stop,increment,clear,rstn,clk,
    output logic cen,increment_once,clear_count
    );
    
    enum logic [1:0]{
        idle_state = 2'b00,
        running_state = 2'b01,
        increment_state = 2'b10,
        clear_state = 2'b11     
    }state,next_state;
    
    always_comb begin
        
        next_state = state;
        
        unique case(state)
            idle_state:begin
                if(start) next_state = running_state;
                else if(increment) next_state = increment_state;
                else if(clear) next_state = clear_state;
            end
            
            running_state:begin
                if(stop) next_state = idle_state;
                else if(clear) next_state = clear_state;
            end
            
            increment_state:begin
                next_state = idle_state;
            end
            
            clear_state:begin
                next_state = idle_state;
            end
            default: next_state = idle_state;
        endcase
    
    end
    
    always_ff @(posedge clk or negedge rstn) begin
        if(!rstn) state <= idle_state;
        else state <= next_state;
    end
    
    always_comb begin
        cen = 0;
        increment_once = 0;
        clear_count = 0;
        
        unique case(state)
            idle_state:begin
            end
            
            running_state:begin
                cen = 1;
            end
            
            increment_state: begin
                increment_once = 1;
            end
            
            clear_state:begin
                clear_count = 1;
            end   
        endcase
    end
endmodule

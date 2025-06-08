

module SevenSegmentControl(
    
        input logic clk, reset, 
        input logic [15:0] dataIn,
        input logic [3:0] digitDisplay,
        input logic [3:0] digitPoint,
        output logic [3:0] anode,
        output logic [7:0] segment
          
    );
    
        parameter integer COUNT_BITS = 17;
        
        logic [COUNT_BITS-1:0]  count_val;
        logic[1:0]              anode_select;
        logic [3:0]             cur_anode;
        logic[3:0]              cur_data_in;
        
        always_ff @(posedge clk) begin
            if(reset)
                count_val <= 0;
            else   
                count_val <= count_val + 1;
        end
        
        assign anode_selct = count_val[COUNT_BITS-1:COUNT_BITS-2];
        
        assign cur_anode =
        (anode_select == 2'b00) ? 4'b1110 :
        (anode_select == 2'b01) ? 4'b1101 :
        (anode_select == 2'b10) ? 4'b1011 :
                                  4'b0111;
        
        assign anode = cur_anode | (~digitDisplay);
        
        assign cur_data_in =
        (anode_select == 2'b00) ? dataIn[3:0] :
        (anode_select == 2'b01) ? dataIn[7:4] :
        (anode_select == 2'b10) ? dataIn[11:8] :
                                  dataIn[15:12];

        assign segment[7] =
        (anode_select == 2'b00) ? ~digitPoint[0] :
        (anode_select == 2'b01) ? ~digitPoint[1] :
        (anode_select == 2'b10) ? ~digitPoint[2] :
                                  ~digitPoint[3];
      
        
         assign segment[6:0] =
        (cur_data_in ==  4'd0)  ? 7'b100_0000 :
        (cur_data_in ==  4'd1)  ? 7'b111_1001 :
        (cur_data_in ==  4'd2)  ? 7'b010_0100 :
        (cur_data_in ==  4'd3)  ? 7'b011_0000 :
        (cur_data_in ==  4'd4)  ? 7'b001_1001 :
        (cur_data_in ==  4'd5)  ? 7'b001_0010 :
        (cur_data_in ==  4'd6)  ? 7'b000_0010 :
        (cur_data_in ==  4'd7)  ? 7'b111_1000 :
        (cur_data_in ==  4'd8)  ? 7'b000_0000 :
        (cur_data_in ==  4'd9)  ? 7'b001_0000 :
        (cur_data_in == 4'd10)  ? 7'b000_1000 : // A
        (cur_data_in == 4'd11)  ? 7'b000_0011 : // b
        (cur_data_in == 4'd12)  ? 7'b100_0110 : // C
        (cur_data_in == 4'd13)  ? 7'b010_0001 : // d
        (cur_data_in == 4'd14)  ? 7'b000_0110 : // E
                                  7'b000_1110 ; // F

        
        
        
endmodule

module mode_counter#(
    parameter MODE_COUNT = 10
)
(
    input  logic clk,
    input  logic rst,
    input  logic cen,
    output logic [4 - 1 : 0] count,
    output logic TC_1001
);

always_ff @(posedge clk or posedge rst ) begin 
    if(rst) begin
        count <= '0;
    end
    else if(cen) begin
        if(count == MODE_COUNT - 1) begin
            count <= '0;
            // TC_1001 <= 1'b1;
        end
        else begin
            count <= count + 1'b1;
            // TC_1001 <= 1'b0;
        end
    end
end

assign TC_1001 = cen && (count == MODE_COUNT - 1);

endmodule   
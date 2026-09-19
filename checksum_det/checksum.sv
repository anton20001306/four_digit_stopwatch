module checksum #(parameter DATA_WIDTH = 16)
(
    input logic clk_i,
    input logic rst_i,
    input logic valid_i,
    input logic load_checksum_i,
    input logic [DATA_WIDTH-1:0] data_i,
    output logic error_o,
    output logic done_o
);

logic [DATA_WIDTH:0] sum;

always_ff @(posedge clk_i or negedge rst_i) begin
    if(!rst_i)begin
        done_o <= 1'b0;
        error_o <= 1'b0;
        sum <= '0;
    end
    else begin

        done_o <= 1'b0;

        if(load_checksum_i) begin
            done_o <= 1'b1;
            error_o <= (sum != 0);
            sum <= '0;
        end
        else if(valid_i) begin
            sum <= sum + {1'b0, data_i};
        end

    end

    end


endmodule
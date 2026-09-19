
module clock_divider #(
    parameter int INPUT_HZ = 100_000_000,
    parameter int OUTPUT_HZ = 1_000
) (
    input  logic clk,
    input  logic rstn,
    output logic divided_clk
);

    // localparam int HALF_PERIOD = INPUT_HZ / (2 * OUTPUT_HZ);
    // localparam int COUNTER_WIDTH = (HALF_PERIOD <= 1) ? 1 : $clog2(HALF_PERIOD);

    // // COUNTER_WIDTH = 16
    // logic [COUNTER_WIDTH-1:0] count;

    localparam int HALF_PERIOD = 50_000;

    logic [15:0] count;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            count       <= '0;
            divided_clk <= 1'b0;
        end
        else if (count == HALF_PERIOD - 1) begin
            count       <= '0;
            divided_clk <= ~divided_clk;
        end
        else begin
            count <= count + 1'b1;
        end
    end

endmodule


module stopwatchtop (
    input logic clk,           
    input logic rstn,          
    input logic start,         
    input logic stop,          
    input logic increment,     
    input logic clear,         
    output logic [7:0] segment,
    output logic [3:0] anode   
);

   
    logic clk_1khz;          
    logic cen;               
    logic increment_once;    
    logic clear_count;       
    logic [15:0] counter_value;  
    
    clock_divider #(
        .INPUT_HZ(100_000_000),
        .OUTPUT_HZ(1_000)
    ) stopwatch_clock (
        .clk(clk),
        .rstn(rstn),
        .divided_clk(clk_1khz)
    );


    
    
    fsm stopwatch_fsm (
        .clk(clk_1khz),
        .rstn(rstn),
        .start(start),
        .stop(stop),
        .increment(increment),
        .clear(clear),
        .cen(cen),
        .increment_once(increment_once),
        .clear_count(clear_count)
    );

    
    
    decimal_counter stopwatch_counter (
        .clk(clk_1khz),
        .rst(!rstn),
        .cen(cen | increment_once),
        .clear(clear_count),
        .out(counter_value)
    );

   
   
    sevensegmentcontrol display_control (
        .clk(clk),
        .reset(!rstn),
        .dispEn(1'b1),
        .dataIn(counter_value),
        .digitDisplay(4'b1111), 
        .digitPoint(3'b100),
        .anode(anode),
        .segment(segment)
    );

endmodule




module fsm (
    input logic clk,           
    input logic rstn,          
    input logic start,         
    input logic stop,          
    input logic increment,     
    input logic clear,         
    output logic cen,          
    output logic increment_once,
    output logic clear_count   
);

    enum logic [2:0] {
        idle_state = 3'b000,
        running_state = 3'b001,
        increment_state = 3'b010,
        clear_state = 3'b011,
        increment_wait_state = 3'b100
    } state, next_state;

    // state logic
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= idle_state;
        else
            state <= next_state;
    end

    // next state logic
    always_comb begin
        next_state = state;

        unique case (state)
            idle_state: begin
                if (clear) next_state = clear_state;
                else if (start) next_state = running_state;
                else if (increment) next_state = increment_state;
            end

            running_state: begin
                if (clear) next_state = clear_state;
                else if (stop) next_state = idle_state;
            end

            increment_state: begin
                next_state = increment_wait_state;
            end

            increment_wait_state: begin
                if (!increment) next_state = idle_state;
            end

            clear_state: begin
                next_state = idle_state;
            end

            default: next_state = idle_state;
        endcase
    end

    // output logic
    always_comb begin
        cen = 0;
        increment_once = 0;
        clear_count = 0;

        unique case (state)
            idle_state: begin
            end

            running_state: begin
                cen = !stop && !clear;
            end

            increment_state: begin
                increment_once = 1;
            end

            clear_state: begin
                clear_count = 1;
            end

            increment_wait_state: begin
            end
        endcase
    end
endmodule




// module counter (
//     input logic clk,           
//     input logic rstn,          
//     input logic cen,           
//     input logic increment_once,
//     input logic clear,         
//     output logic [15:0] counter_value 
    
// );

//     always_ff @(posedge clk or negedge rstn) begin
//         if (!rstn)
//             counter_value <= 16'd0;
//         else if (clear)
//             counter_value <= 16'd0;
//         else if (increment_once)
//             counter_value <= counter_value + 1'b1;
//         else if (cen)
//             counter_value <= counter_value + 1'b1;
//     end
// endmodule

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

module decimal_counter #(
    parameter WIDTH = 16,
    parameter MODE_COUNT = 10
)(
    input logic clk,
    input logic rst,
    input logic cen, // increment
    input logic clear,
    output logic [WIDTH - 1:0] out
);

logic r0, r1, r2, r3;
logic count_reset;

assign count_reset = rst || clear;

mode_counter #(.MODE_COUNT(MODE_COUNT)) md1(
    .clk(clk),
    .rst(count_reset),
    .cen(cen),
    .count(out[3:0]),
    .TC_1001(r0)
);

mode_counter #(.MODE_COUNT(MODE_COUNT)) md2(
    .clk(clk),
    .rst(count_reset),
    .cen(r0),
    .count(out[7:4]),
    .TC_1001(r1)
);

mode_counter #(.MODE_COUNT(MODE_COUNT)) md3(
    .clk(clk),
    .rst(count_reset),
    .cen(r1),
    .count(out[11:8]),
    .TC_1001(r2)
);

mode_counter #(.MODE_COUNT(MODE_COUNT)) md4(
    .clk(clk),
    .rst(count_reset),
    .cen(r2),
    .count(out[15:12]),
    .TC_1001(r3)
);

endmodule


// `default_nettype none

module sevensegmentcontrol (
    input wire logic            clk,
    input wire logic            reset,
    input wire logic            dispEn,       // NEW: Disp_EN from Fig. 7
    input wire logic    [15:0]  dataIn,
    input wire logic    [3:0]   digitDisplay,
    input wire logic    [2:0]   digitPoint,   // CHANGED: 4 bits -> 3 bits (matches DP[3] in Fig. 7)
    output logic        [3:0]   anode,
    output logic        [7:0]   segment
    );

    parameter integer COUNT_BITS = 17;

    logic   [COUNT_BITS-1:0]    count_val;
    logic   [1:0]               anode_select;
    logic   [3:0]               cur_anode;
    logic   [3:0]               cur_data_in;

    // ---- Refresh counter ----
    // dispEn drives CEN in Fig. 7: while low, the counter holds its
    // current value, so the display simply stops refreshing/cycling.
    always_ff @(posedge clk) begin
        if (reset)
            count_val <= 0;
        else if (dispEn)
            count_val <= count_val + 1;
        // else: hold - counter is disabled
    end

    // Signal to indicate which anode we are driving
    assign anode_select = count_val[COUNT_BITS-1:COUNT_BITS-2];

    // current anode (active-low, one-hot: only one digit driven at a time)
    assign cur_anode =
        (anode_select == 2'b00) ? 4'b1110 :
        (anode_select == 2'b01) ? 4'b1101 :
        (anode_select == 2'b10) ? 4'b1011 :
        4'b0111 ;

    // Mask anode values that are not enabled with digit display, AND
    // blank ALL anodes when dispEn is low (drives EN on the 2:4 decoder
    // in Fig. 7 - decoder disabled means no anode is ever selected).
    assign anode = dispEn ? (cur_anode | (~digitDisplay)) : 4'b1111;

    // This is a statement to simulate a common student problem when the
    // anode is "stuck". This statement is used to make sure the testbench
    // catches this condition.
    //assign anode = 8'hff;

    assign cur_data_in =
        (anode_select == 2'b00) ? dataIn[3:0] :
        (anode_select == 2'b01) ? dataIn[7:4] :
        (anode_select == 2'b10) ? dataIn[11:8]:
        dataIn[15:12] ;

    // ---- Decimal point (Dec. Pnt. Decoder in Fig. 7) ----
    // digitPoint is 3 bits: one bit per possible DP position between the
    // 4 digits (digit0, digit1, digit2). digit3 (leftmost/most-significant)
    // never carries a decimal point in a 4-digit display, matching the
    // 3-bit width shown in Fig. 7 (as opposed to 4 independent per-digit bits).
    assign segment[7] =
        (anode_select == 2'b00) ? ~digitPoint[0] :
        (anode_select == 2'b01) ? ~digitPoint[1] :
        (anode_select == 2'b10) ? ~digitPoint[2] :
        1'b1 ;   // digit3: DP segment always off

    assign segment[6:0] =
        (cur_data_in ==  0) ? 7'b1000000 :
        (cur_data_in ==  1) ? 7'b1111001 :
        (cur_data_in ==  2) ? 7'b0100100 :
        (cur_data_in ==  3) ? 7'b0110000 :
        (cur_data_in ==  4) ? 7'b0011001 :
        (cur_data_in ==  5) ? 7'b0010010 :
        (cur_data_in ==  6) ? 7'b0000010 :
        (cur_data_in ==  7) ? 7'b1111000 :
        (cur_data_in ==  8) ? 7'b0000000 :
        (cur_data_in ==  9) ? 7'b0010000 :
        (cur_data_in == 10) ? 7'b0001000 :
        (cur_data_in == 11) ? 7'b0000011 :
        (cur_data_in == 12) ? 7'b1000110 :
        (cur_data_in == 13) ? 7'b0100001 :
        (cur_data_in == 14) ? 7'b0000110 :
        7'b0001110 ;

endmodule

// module SevenSegmentControl (
//     input wire logic clk,
//     input wire logic reset,
//     input wire logic [15:0] dataIn,
//     input wire logic [3:0] digitDisplay,
//     input wire logic [3:0] digitPoint,
//     output logic [3:0] anode,
//     output logic [7:0] segment
// );

//     parameter integer COUNT_BITS = 17;

//     logic [COUNT_BITS-1:0] count_val;
//     logic [1:0] anode_select;
//     logic [3:0] cur_anode;
//     logic [3:0] cur_data_in;

    
    
//     always_ff @(posedge clk) begin
//         if (reset)
//             count_val <= 0;
//         else
//             count_val <= count_val + 1;
//     end

   
   
//     assign anode_select = count_val[COUNT_BITS-1:COUNT_BITS-2];

    
    
//     assign cur_anode =
//         (anode_select == 2'b00) ? 4'b1110 :
//         (anode_select == 2'b01) ? 4'b1101 :
//         (anode_select == 2'b10) ? 4'b1011 :
//         4'b0111;

    
    
//     assign anode = cur_anode | (~digitDisplay);

   
   
//     assign cur_data_in =
//         (anode_select == 2'b00) ? dataIn[3:0] :
//         (anode_select == 2'b01) ? dataIn[7:4] :
//         (anode_select == 2'b10) ? dataIn[11:8]:
//         dataIn[15:12];

    
    
//     assign segment[7] =
//         (anode_select == 2'b00) ? ~digitPoint[0] :
//         (anode_select == 2'b01) ? ~digitPoint[1] :
//         (anode_select == 2'b10) ? ~digitPoint[2] :
//         ~digitPoint[3];

    
    
//     assign segment[6:0] =
//         (cur_data_in ==  0) ? 7'b1000000 :
//         (cur_data_in ==  1) ? 7'b1111001 :
//         (cur_data_in ==  2) ? 7'b0100100 :
//         (cur_data_in ==  3) ? 7'b0110000 :
//         (cur_data_in ==  4) ? 7'b0011001 :
//         (cur_data_in ==  5) ? 7'b0010010 :
//         (cur_data_in ==  6) ? 7'b0000010 :
//         (cur_data_in ==  7) ? 7'b1111000 :
//         (cur_data_in ==  8) ? 7'b0000000 :
//         (cur_data_in ==  9) ? 7'b0010000 :
//         (cur_data_in == 10) ? 7'b0001000 :
//         (cur_data_in == 11) ? 7'b0000011 :
//         (cur_data_in == 12) ? 7'b1000110 :
//         (cur_data_in == 13) ? 7'b0100001 :
//         (cur_data_in == 14) ? 7'b0000110 :
//         7'b0001110;
// endmodule

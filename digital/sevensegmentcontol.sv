
`default_nettype none

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
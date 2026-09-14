module decimal_counter #(
    parameter WIDTH = 16,
    parameter MODE_COUNT = 10s
)(
    input logic clk,
    input logic rst,
    input logic cen, // increment
    output logic [WIDTH - 1:0] out
);

logic r0, r1, r2, r3;

mode_counter #(.MODE_COUNT(MODE_COUNT)) md1(
    .clk(clk),
    .rst(rst),
    .cen(cen),
    .count(out[3:0]),
    .TC_1001(r0)
);

mode_counter #(.MODE_COUNT(MODE_COUNT)) md2(
    .clk(clk),
    .rst(rst),
    .cen(r0),
    .count(out[7:4]),
    .TC_1001(r1)
);

mode_counter #(.MODE_COUNT(MODE_COUNT)) md3(
    .clk(clk),
    .rst(rst),
    .cen(r1),
    .count(out[11:8]),
    .TC_1001(r2)
);

mode_counter #(.MODE_COUNT(MODE_COUNT)) md4(
    .clk(clk),
    .rst(rst),
    .cen(r2),
    .count(out[15:12]),
    .TC_1001(r3)
);

endmodule
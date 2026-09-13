module n_adder #(
    parameter N = 8
)(
    input  logic signed [N - 1:0] A, B,
    input  logic ci,
    output logic signed [N-1: 0] S,
    output logic co
);

logic C[N:0];       // unpacked array just like noraml array, but each element is a single bit
assign C[0] = ci;   // store the first carry as input element
assign co = C[N];   // store the last carry as output element

genvar i;
for(i = 0; i < N; i++) begin: adder_loop
    full_adder fa(
        .A(A[i]),
        .B(B[i]),
        .ci(C[i]),
        .S(S[i]),
        .co(C[i+1])
    );
end
endmodule 

module full_adder (
    input logic A, B, ci,
    output logic S, co
);
    
assign {co, S} = A + B + ci;

endmodule
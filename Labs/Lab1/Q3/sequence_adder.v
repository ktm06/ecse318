module sequence_adder(sum, O0, O1, O2, O3, O4, O5, O6, O7, O8, O9);

output [11:0] sum;
input [7:0] O0, O1, O2, O3, O4, O5, O6, O7, O8, O9;
wire [11:0] CSA_8[0:6], CSA_9[0:4], CSA_10[0:3], CSA_11[0:2], CSA_12;
wire [11:0] carry_9[0:2], carry_10[0:1], carry_11[0:1], carry_12, carry_13;

// 10 operands -> 7 operands
genvar i;
generate
    for (i = 0; i < 12; i = i + 1)
    begin
        CSA_stage U1_1 (.s(CSA_8[0][i]), .c_out(carry_9[0][i + 1]), .a(O0[i]), .b(O1[i]), .c(O2[i]));
        CSA_stage U1_2 (.s(CSA_8[1][i]), .c_out(carry_9[1][i + 1]), .a(O3[i]), .b(O4[i]), .c(O5[i]));
        CSA_stage U1_3 (.s(CSA_8[2][i]), .c_out(carry_9[2][i + 1]), .a(O6[i]), .b(O7[i]), .c(O8[i]));
    end
endgenerate

assign carry_9[0][0] = 1'b0;
assign carry_9[1][0] = 1'b0;
assign carry_9[2][0] = 1'b0;
assign CSA_8[3] = carry_9[0][12:0];
assign CSA_8[4] = carry_9[1][12:0];
assign CSA_8[5] = carry_9[2][12:0];
assign CSA_8[6] = O9;

// 7 operands -> 5 operands
genvar i;
generate
    for (i = 0; i < 12; i = i + 1)
    begin
        CSA_stage U2_1 (.s(CSA_9[0][i]), .c_out(carry_10[0][i + 1]), .a(CSA_8[0][i]), .b(CSA_8[1][i]), .c(CSA_8[2][i]));
        CSA_stage U2_2 (.s(CSA_9[1][i]), .c_out(carry_10[1][i + 1]), .a(CSA_8[3][i]), .b(CSA_8[4][i]), .c(CSA_8[5][i]));
    end
endgenerate

assign carry_10[0][0] = 1'b0;
assign carry_10[1][0] = 1'b0;
assign CSA_9[2] = carry_10[0][12:0];
assign CSA_9[3] = carry_10[1][12:0];
assign CSA_9[4] = CSA_8[6];

// 5 operands -> 4 operands
genvar i;
generate
    for (i = 0; i < 12; i = i + 1)
    begin
        CSA_stage U3_1 (.s(CSA_10[0][i]), .c_out(carry_11[0][i + 1]), .a(CSA_9[0][i]), .b(CSA_9[1][i]), .c(CSA_9[2][i]));
        CSA_stage U3_2 (.s(CSA_10[1][i]), .c_out(carry_11[1][i + 1]), .a(CSA_9[3][i]), .b(CSA_9[4][i]), .c(1'b0));
    end
endgenerate

assign carry_11[0][0] = 1'b0;
assign carry_11[1][0] = 1'b0;
assign CSA_10[2] = carry_11[0][12:0];
assign CSA_10[3] = carry_11[1][12:0];

// 4 operands -> 3 operands
genvar i;
generate
    for (i = 0; i < 12; i = i + 1)
    begin
        CSA_stage U4_1 (.s(CSA_11[0][i]), .c_out(carry_12[i + 1]), .a(CSA_10[0][i]), .b(CSA_10[1][i]), .c(CSA_10[2][i]));
    end
endgenerate

assign carry_12[0] = 1'b0;
assign CSA_11[1] = carry_12[12:0];
assign CSA_11[2] = CSA_10[3];

// 3 operands -> 2 operands
genvar i;
generate
    for (i = 0; i < 12; i = i + 1)
    begin
        CSA_stage U5_1 (.s(CSA_12[i]), .c_out(carry_13[i + 1]), .a(CSA_11[0][i]), .b(CSA_11[1][i]), .c(CSA_11[2][i]));
    end
endgenerate

assign carry_13[0] = 1'b0;
assign sum = CSA_12 + carry_13;

endmodule
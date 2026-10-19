`timescale 1ns/1ps
`default_nettype none


module ConditionalSumAdder (
    input  wire [7:0] X, Y,
    input  wire       Cin,
    output wire [7:0] S,
    output wire       Co
);

    //bit 0
    wire [1:0] r0;
    assign r0   = X[0] + Y[0] + Cin;
    wire   c1   = r0[1];
    assign S[0] = r0[0];

    //bit 1
    wire [1:0] l1_0, l1_1, r1;
    Leaf l1 (.X(X[1]), .Y(Y[1]), .S0(l1_0), .S1(l1_1));
    Resolve #(.width(1)) res1 (.cin(c1), .S0(l1_0), .S1(l1_1), .S(r1));
    wire   c2   = r1[1];
    assign S[1] = r1[0];

    //bits 3:2
    wire [1:0] l2_0, l2_1, l3_0, l3_1;
    Leaf l2 (.X(X[2]), .Y(Y[2]), .S0(l2_0), .S1(l2_1));
    Leaf l3 (.X(X[3]), .Y(Y[3]), .S0(l3_0), .S1(l3_1));

    wire [2:0] m32_0, m32_1, r32;
    Merge #(.width(1)) m32 (.L0(l2_0), .L1(l2_1), .H0(l3_0), .H1(l3_1),.S0(m32_0), .S1(m32_1));
    Resolve #(.width(2)) res32 (.cin(c2), .S0(m32_0), .S1(m32_1), .S(r32));
    wire   c4     = r32[2];
    assign S[3:2] = r32[1:0];

    //bits 7:4
    wire [1:0] l4_0, l4_1, l5_0, l5_1, l6_0, l6_1, l7_0, l7_1;
    Leaf l4 (.X(X[4]), .Y(Y[4]), .S0(l4_0), .S1(l4_1));
    Leaf l5 (.X(X[5]), .Y(Y[5]), .S0(l5_0), .S1(l5_1));
    Leaf l6 (.X(X[6]), .Y(Y[6]), .S0(l6_0), .S1(l6_1));
    Leaf l7 (.X(X[7]), .Y(Y[7]), .S0(l7_0), .S1(l7_1));

    wire [2:0] m54_0, m54_1, m76_0, m76_1;
    Merge #(.width(1)) m54 (.L0(l4_0), .L1(l4_1), .H0(l5_0), .H1(l5_1),.S0(m54_0), .S1(m54_1));
    Merge #(.width(1)) m76 (.L0(l6_0), .L1(l6_1), .H0(l7_0), .H1(l7_1),.S0(m76_0), .S1(m76_1));

    wire [4:0] m74_0, m74_1, r74;
    Merge #(.width(2)) m74 (.L0(m54_0), .L1(m54_1), .H0(m76_0), .H1(m76_1),.S0(m74_0), .S1(m74_1));
    Resolve #(.width(4)) res74 (.cin(c4), .S0(m74_0), .S1(m74_1), .S(r74));
    assign Co     = r74[4];
    assign S[7:4] = r74[3:0];

endmodule

module Leaf (
    input  wire       X, Y,
    output wire [1:0] S0, S1
);
    assign S0 = X + Y;
    assign S1 = X + Y + 1;
endmodule


module Merge #(parameter width = 1) (
    input  wire [width:0]   L0, L1, H0, H1,
    output wire [width*2:0] S0, S1
);
    assign S0 = {L0[width] ? H1 : H0, L0[width-1:0]};
    assign S1 = {L1[width] ? H1 : H0, L1[width-1:0]};
endmodule


module Resolve #(parameter width = 1) (
    input  wire             cin,
    input  wire [width:0]   S0, S1,
    output wire [width:0]   S
);
    assign S = cin ? S1 : S0;
endmodule

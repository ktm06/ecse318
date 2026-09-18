`timescale 1ns/1ps

module cla(
    input [3:0] a, 
    input [3:0] b, 
    input cin, 
    output [3:0] s);

// prop & generate
wire [3:0] p, g;

// carry
wire [3:0] c;

// intermediate terms
wire p0c, p1g0, p1p0c, p2g1, p2p1g0, p2p1p0c;

// 
and #10 (g[0], a[0], b[0]);
xor #10 (p[0], a[0], b[0]);
xor #10 (s[0], cin, p[0]);
and #10 (g[1], a[1], b[1]);
xor #10 (p[1], a[1], b[1]);
xor #10 (s[1], c[0], p[1]);
and #10 (g[2], a[2], b[2]);
xor #10 (p[2], a[2], b[2]);
xor #10 (s[2], c[1], p[2]);
and #10 (g[3], a[3], b[3]);
xor #10 (p[3], a[3], b[3]);
xor #10 (s[3], c[2], p[3]);

and #10 (p0c, p[0], cin);
or  #10 (c[0], g[0], p0c);

and #10 (p1g0, p[1], g[0]);
and #10 (p1p0c, p[1], p[0], cin);
or  #10 (c[1], g[1], p1g0, p1p0c);

and #10 (p2g1, p[2], g[1]);
and #10 (p2p1g0, p[2], p[1], g[0]);
and #10 (p2p1p0c, p[2], p[1], p[0], cin);
or  #10 (c[2], g[2], p2g1, p2p1g0, p2p1p0c);

endmodule
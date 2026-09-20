module CSA_stage (s, c_out, a, b, c);

output s;
output c_out;
input a, b, c;
wire p, g;

assign p = a ^ b;
assign g = a & b;
assign s = p ^ c;
assign c_out = g | (c & p);
endmodule
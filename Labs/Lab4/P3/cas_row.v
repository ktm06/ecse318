module cas_row (
    input wire [3:0] m,
    input wire [3:0] d,
    input wire control,
    output wire [3:0] out,
    output wire q
);
// go from right to left in diagram
genvar i;
wire [4:0] cout;
assign cout[0] = control;
assign q = cout[4];
generate for (i = 0; i < 4; i= i+1) begin
    cas add_sub(
        .a(d[i]),
        .b(m[i]),
        .m(control),
        .cin(cout[i]),
        .s(out[i]),
        .cout(cout[i+1])
    );
end
endgenerate

endmodule
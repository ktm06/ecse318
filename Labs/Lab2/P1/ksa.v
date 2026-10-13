module ksa #(
    parameter N = 16
) (
    input wire [N-1:0] A,
    input wire [N-1:0] B,
    input wire cin,
    output reg [N-1:0] out,
    output reg cout
);

// this is the kogge stone adder, which is the fastest adder 
reg [N-1:0] p0;
reg [N-1:0] g, p;

reg [N-1:0] g_next, p_next;

reg [N:0] carry;

integer i;
integer d;

always @(*) begin
    p0 = A ^ B;
    g = A & B;
    p = p0;
    g[0] = g[0] | (p[0] & cin);

    for (d = 1; d < N; d = d * 2) begin
        g_next = g;
        p_next = p;

        for (i = d; i < N; i = i + 1) begin
            g_next[i] = g[i] | (p[i] & g[i-d]);
            p_next[i] = p[i] & p[i-d];
        end

        g = g_next;
        p = p_next;

    end

    carry = {g, cin};
    out = p0 ^ carry[N-1:0];
    cout = carry[N];

end


endmodule
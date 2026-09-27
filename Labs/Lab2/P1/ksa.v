module ksa #(
    parameter N = 16
) (
    input [N-1:0] wire A,
    input [N-1:0] wire B,
    input cin,
    output [N-1:0] out,
    output cout
)

// this is the kogge stone adder, which is the fastest adder 
reg [N-1:0] p0;
reg [N-1:0] g, p;

reg [N-1:0] g_next, p_next;

reg [N:0] carry;

integer i;
integer d;

always @(*) begin
    p0 = a ^ b;
    g = a & b;
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
    sum = p0 ^ carry[N-1:0];
    cout = carry[N];

end


endmodule
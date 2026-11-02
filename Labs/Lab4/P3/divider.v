module divider(
    input [3:0] m, // divisor
    input [3:0] d, // divedend 
    output [3:0] q,
    output [3:0] r
);
    genvar i;
    wire [3:0] row_in [0:3]; // the blocks that go down
    wire [3:0] row_out [0:3];
    wire [3:0] qb;
    wire [3:0] m_fix; // corrector

    assign q = {qb[0], qb[1], qb[2], qb[3]};
    generate 
        for (i = 0; i < 4; i = i + 1) begin
            if (i == 0) begin
                assign row_in[i] = {3'b000, d[3]}; // initial row input
            end else begin
                assign row_in[i] = {row_out[i-1][2:0], d[3-i]};
            end

            cas_row row (
                .m (m),
                .d (row_in[i]),
                .control((i == 0) ? 1'b1 : qb[i-1]),
                .out (row_out[i]),
                .q (qb[i])
            );

            
        end
    endgenerate
    assign m_fix = qb[3] ? 4'b0000 : m;
    cas_row fix (.m(m_fix), 
                .d(row_out[3]), 
                .control(1'b0), 
                .out(r), 
                .q()); // corrector
endmodule
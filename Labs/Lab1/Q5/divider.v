module divider #(
    parameter N = 4,
    parameter CNT = 4
) (
    input [N-1:0] divisor, // divisor
    input [N-1:0] divident, // divedent
    output [N-1:0] q,
    output [N-1:0] r,
    input clk,
    input reset,
    input start
);
    reg [N-1:0] D, M, R;
    reg [2:0] CNT;
    assign divisor_reg = m;
    assign divident_reg = d;
    

    cas_row row (
                .m (m),
                .d (d),
                .control((i == 0) ? 1'b1 : qb[i-1]),
                .out (row_out[i]),
                .q (qb[i])
            );

    always @(posedge clk or posedge reset) begin
        if (reset) begin //regclear
            R <= '0;
            D <= '0;
            M <= '0;
        end else begin 
            

        end
    end


endmodule
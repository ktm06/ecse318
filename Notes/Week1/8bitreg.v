module register (q, d, reset_l, clk);

output [7:0] q;
input [7:0] d;
input reset_l, clk;

reg [7:0] q;

always @(posedge clk or negedge reset_l) begin
    if (!reset_l) begin
        q = 8'b0;
    end else begin
        q = d;
    end
end

endmodule
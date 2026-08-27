module sreg8 (q, d, load shift_in, reset_l, clk);
    output [7:0] q;
    input [7:0] d;
    input load, shift_in, reset_l, clk;
    reg [7:0] q;

    always @(posedge clk or negedge reset_l) begin
        if (!reset_l)  q = 8'b0;
        else if (load) q = d;
        else q={q[6:0], shift_in};
    end

endmodule
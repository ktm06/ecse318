module ex2 (z, x, clkrs);
    input clk, rs;
    input [1:0] x;
    output out;
    reg out;
    reg [1:0] state;
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;
    reg [1:0] D;
    always @(x or q) begin
        if (rs) begin
            state = S0;
            out = 1'b0;
        end else begin
            case (state) 
                S0: begin end
            endcase
        end
    end
endmodule
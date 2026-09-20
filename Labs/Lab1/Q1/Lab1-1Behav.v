module top_module_behav #(parameter bits = 8) (input wire clk, input wire load, input wire [bits-1:0]a, input wire [bits-1:0]b, output reg [bits-1:0]sum);
    reg [bits-1:0] a_q, b_q;
    reg carry;
    wire s, cout;

    assign {cout, s} = a_q[0] + b_q[0] + carry;

    always @(posedge clk) begin
        if (load) begin
            a_q   <= a;
            b_q   <= b;
            carry <= 1'b0;
        end
        else begin
            a_q   <= a_q >> 1;
            b_q   <= b_q >> 1;
            carry <= cout;
        end
        sum <= {s, sum[bits-1:1]};
    end

endmodule

module divider #(
    parameter N = 4,
    parameter CNT = 4
) (
    input wire[N-1:0] divisor, // divisor
    input wire[N-1:0] divident, // divedent
    output wire [N-1:0] q,
    output wire [N-1:0] r,

    input wire clk,
    input wire reset,
    input wire start
);
    reg [N-1:0] D, M;
    reg [N:0] R;
    wire [N:0] Mwide, R_N, sum;
    integer count;
    wire control; // 0 is add, 1 is sub

    wire sign = R[N];
    assign control = ~sign;

    assign R_N = (count == 1) ? R : {R[N-1:0], D[N-1]}; // Mux
    assign Mwide = {1'b0, M};
    assign sum = control ? (R_N - Mwide) : (R_N + Mwide); // fa
    always @(posedge clk or posedge reset) begin
        if (reset) begin //regclear
            R <= '0;
            D <= '0;
            M <= '0;
            count <= 0;
        end else begin 
            if (start) begin
                D <= divident;
                M <= divisor;
                R <= '0;
                count <= CNT + 1;
            end else begin
                if (count > 1) begin
                    count <= count - 1;
                    R <= sum;
                    if (count == CNT + 1) begin
                        D <= {D[N-2:0], 1'b0};
                    end else begin
                        D <= {D[N-2:1], ~sign, 1'b0};
                    end
                end else if (count == 1) begin
                    count <= 0;
                    D[0] <= ~sign;
                end
            end
        end
    end

    assign q = D;
    assign r = R[N-1:0];

endmodule
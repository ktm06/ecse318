module ALU_16Bit_TopLevel (
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [4:0] alu_code,
    output reg [15:0] C,
    output reg overflow
);

reg [15:0] y;
reg cin;
wire [15:0] sum;
wire cout;

ksa #(.N(16)) adder (
    .A(A),
    .B(y),
    .cin(cin),
    .out(sum),
    .cout(cout)
)


always @(*) begin
    case (alu_code)
        // arithmetic
        5'b00000: begin // sadd
            C = sum;
            if (C[15] == 1'b1 & A[15] == 1'b0 & B[15] == 1'b0) begin
                overflow = 1'b1;
            end else if (C[15] == 1'b0 & A[15] == 1'b1 & B[15] == 1'b1) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00001: begin //uadd
            {overflow, C} = {cout, sum};
        end
        5'b00010: begin //ssub
            y = ~B;
            cin = 1'b1;
            C = sum;
            if (C[15] == 1'b1 & A[15] == 1'b0 & B[15] == 1'b1) begin
                overflow = 1'b1;
            end else if (C[15] == 1'b0 & A[15] == 1'b1 & B[15] == 1'b0) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00011: begin //usub
            y = ~B;
            cin = 1'b1;
            {overflow, C} = {~cout, sum};
        end
        5'b00100: begin  //signed inc
            y = 16'd0;
            cin = 1'b1;
            C = sum;
            if (C[15] == 1'b1 & A[15] == 1'b0) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00101: begin //signed dec
            y = 16'hFFFF;
            C = sum;
            if (C[15] == 1'b0 & A[15] == 1'b1) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        
        // logic
        5'b01000: begin //and
            C = A & B;
            overflow = 1'b0;
        end
        5'b01001: begin //or
            C = A | B;
            overflow = 1'b0;
        end
        5'b01010: begin //xor
            C = A ^ B;
            overflow = 1'b0;
        end
        5'b01100: begin //not
            C = ~A;
            overflow = 1'b0;
        end

        // shift
        5'b10000: begin //sll
            C = A << B[3:0];
            overflow = 1'b0;
        end
        5'b10001: begin //srl
            C = A >> B[3:0];
            overflow = 1'b0;
        end
        5'b10010: begin //sla
            C = A <<< B[3:0];
            overflow = 1'b0;
        end
        5'b10011: begin //sra
            C = A >>> B[3:0];
            overflow = 1'b0;
        end

        //set
        5'b11000: begin //sle
            if (A <= B) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11001: begin //slt
        if (A < B) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11010: begin //sge
        if (A >= B) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11011: begin //sgt
        if (A > B) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11100: begin //seq
        if (A == B) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11101: begin //sne
        if (A != B) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        default: begin
            C = 16'd0;
            overflow = 16'd0;
        end
    endcase

end


endmodule
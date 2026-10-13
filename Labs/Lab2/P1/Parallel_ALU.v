module Parallel_ALU (
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [4:0] alu_code,
    output reg [15:0] C,
    output reg overflow
);

wire [15:0] sum_add, sum_sub, sum_inc, sum_dec;
wire cout_add, cout_sub, cout_inc, cout_dec;

ksa #(.N(16)) adder_add (
        .A(A),
        .B(B), 
        .cin(1'b0), 
        .out(sum_add), 
        .cout(cout_add));
ksa #(.N(16)) adder_sub (
        .A(A),
        .B(~B),
        .cin(1'b1),
        .out(sum_sub),
        .cout(cout_sub));
ksa #(.N(16)) adder_inc (
        .A(A),
        .B(16'd0),
        .cin(1'b1),
        .out(sum_inc),
        .cout(cout_inc));
ksa #(.N(16)) adder_dec (
        .A(A),
        .B(16'hFFFF),
        .cin(1'b0),
        .out(sum_dec),
        .cout(cout_dec));

always @(*) begin
    case (alu_code)
        // arithmetic
        5'b00000: begin // sadd
            C = sum_add;
            if (C[15] == 1'b1 & A[15] == 1'b0 & B[15] == 1'b0) begin
                overflow = 1'b1;
            end else if (C[15] == 1'b0 & A[15] == 1'b1 & B[15] == 1'b1) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00001: begin //uadd
            {overflow, C} = {cout_add, sum_add};
        end
        5'b00010: begin //ssub
            C = sum_sub;
            if (C[15] == 1'b1 & A[15] == 1'b0 & B[15] == 1'b1) begin
                overflow = 1'b1;
            end else if (C[15] == 1'b0 & A[15] == 1'b1 & B[15] == 1'b0) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00011: begin //usub
            {overflow, C} = {~cout_sub, sum_sub};
        end
        5'b00100: begin  //signed inc
            C = sum_inc;
            if (C[15] == 1'b1 & A[15] == 1'b0) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00101: begin //signed dec
            C = sum_dec;
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
            C = $signed(A) << B[3:0];
            overflow = 1'b0;
        end
        5'b10001: begin //srl
            C = $signed(A) >> B[3:0];
            overflow = 1'b0;
        end
        5'b10010: begin //sla
            C = $signed(A) <<< B[3:0];
            overflow = 1'b0;
        end
        5'b10011: begin //sra
            C = $signed(A) >>> B[3:0];
            overflow = 1'b0;
        end

        //set
        5'b11000: begin //sle
            if ($signed(A) <= $signed(B)) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11001: begin //slt
        if ($signed(A) < $signed(B)) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11010: begin //sge
        if ($signed(A) >= $signed(B)) begin
                C = 16'd1;
            end else begin
                C = 16'd0;
            end
            overflow = 1'b0;
        end
        5'b11011: begin //sgt
        if ($signed(A) > $signed(B)) begin
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
            overflow = 1'b0;
        end
    endcase

end


endmodule
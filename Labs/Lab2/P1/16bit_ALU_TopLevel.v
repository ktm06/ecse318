module 16bit_ALU_TopLevel(
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [4:0] alu_code,
    output wire [15:0] C,
    output wire overflow
)

always @(*) begin
    case (alu_code)
        // arithmetic
        5'b00000: begin // sadd
            C = $signed(A) + $signed(B);
            if (C[15] == 1'b1 & A[15] == 1'b0 & B[15] == 1'b0) begin
                overflow == 1'b1;
            end else if (C[15] == 1'b0 & A[15] == 1'b1 & B[15] == 1'b1) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00001: begin //uadd
            {overflow, C} = A + B;
        end
        5'b00010: begin //ssub
            C = $signed(A) - $signed(B);
            if (C[15] == 1'b1 & A[15] == 1'b0 & B[15] == 1'b1) begin
                overflow == 1'b1;
            end else if (C[15] == 1'b0 & A[15] == 1'b1 & B[15] == 1'b0) begin
                overflow = 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00011: begin //usub
            {ovwrflow, C} = A - B;
        end
        5'b00100: begin  //signed inc
            C = $signed(A) + 16'b1;
            if (C[15] == 1'b1 & A[15] == 1'b0) begin
                overflow == 1'b1;
            end else begin
                overflow = 1'b0;
            end
        end
        5'b00101: begin //signed dec
            C = $signed(A) - 16'b1;
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
            C = A << B;
            overflow = 1'b0;
        end
        5'b10001: begin //srl
            C = A >> B;
            overflow = 1'b0;
        end
        5'b10010: begin //sla
            C = A <<< B;
            overflow = 1'b0;
        end
        5'b10011: begin //sra
            C = A >>> B;
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
    endcase

end


endmodule
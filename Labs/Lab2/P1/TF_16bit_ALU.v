module TF_16bit_ALU();
reg [15:0] A;
reg [15:0] B;
wire [15:0] C;
reg [4:0] instruction;
wire overflow;

localparam [4:0]
    ADD = 5'b00000,
    ADDU = 5'b00001,
    SUB = 5'b00010,
    SUBU = 5'b00011,
    INC = 5'b00100,
    DEC = 5'b00101,
    AND = 5'b01000,
    OR = 5'b01001,
    XOR = 5'b01010,
    NOT = 5'b01100,
    SLL = 5'b10000,
    SRL = 5'b10001,
    SLA = 5'b10010,
    SRA = 5'b10011,
    SLE = 5'b11000,
    SLT = 5'b11001,
    SGE = 5'b11010,
    SGT = 5'b11011,
    SEQ = 5'b11100,
    SNE = 5'b11101;

    task instr;
        input [4:0] op;
        input [15:0] a;
        input [15:0] b;
        begin
            instruction = op;
            A = a;
            B = b;
            #10;
            $display("op=%b  A=%h  B=%h  ->  C=%h  overflow=%b", op, a, b, C, overflow);

        end

    endtask
    ALU_16Bit_TopLevel uut (
        .A(A),
        .B(B),
        .alu_code(instruction),
        .C(C),
        .overflow(overflow)
    );
initial begin
    instr(ADD,  16'h0000, 16'h0001);
    instr(ADD,  16'h000F, 16'h000F);
    instr(ADD,  16'h7F00, 16'h0300);
    instr(ADD,  16'hFF00, 16'h0100);
    instr(ADD,  16'h8100, 16'h8000);
    instr(ADDU, 16'h0000, 16'h0001);
    instr(ADDU, 16'h000F, 16'h000F);
    instr(ADDU, 16'h7F00, 16'h0300);
    instr(ADDU, 16'hFF00, 16'h0100);
    instr(ADDU, 16'h8100, 16'h8000);
    instr(SUB,  16'h0000, 16'h0001);
    instr(SUB,  16'h000F, 16'h000F);
    instr(SUB,  16'h7F00, 16'h0300);
    instr(SUB,  16'hFF00, 16'h0100);
    instr(SUB,  16'h8100, 16'h8000);
    instr(SUBU, 16'h0000, 16'h0001);
    instr(SUBU, 16'hFF00, 16'hFCE0);
    instr(SUBU, 16'h7F00, 16'h0300);
    instr(SUBU, 16'hFF00, 16'h0100);
    instr(SUBU, 16'h8100, 16'h8000);
    instr(INC,  16'h0000, 16'h0100);
    instr(INC,  16'h0F00, 16'h0F00);
    instr(INC,  16'h7FFF, 16'h0300);
    instr(INC,  16'hFF00, 16'h0100);
    instr(INC,  16'h8100, 16'h8000);
    instr(DEC,  16'h0000, 16'h0100);
    instr(DEC,  16'h000F, 16'h000F);
    instr(DEC,  16'h7F00, 16'h0300);
    instr(DEC,  16'hFF00, 16'h0100);
    instr(DEC,  16'h8000, 16'h8000);
    instr(AND,  16'hF0F0, 16'hFF00);
    instr(OR,   16'hF0F0, 16'h0F0F);
    instr(XOR,  16'hAAAA, 16'hFFFF);
    instr(NOT,  16'h1234, 16'h0000);
    instr(SLL,  16'h0001, 16'h000F);
    instr(SRL,  16'h8000, 16'h000F);
    instr(SLA,  16'h4001, 16'h0001);
    instr(SRA,  16'hF000, 16'h0004);
    instr(SRA,  16'h7000, 16'hFFF4);
    instr(SLE,  16'h8000, 16'h7FFF);
    instr(SLT,  16'hFFFF, 16'h0001);
    instr(SGE,  16'h7FFF, 16'h8000);
    instr(SGT,  16'hFFFF, 16'h0001);
    instr(SEQ,  16'hBEEF, 16'hBEEF);
    instr(SNE,  16'hBEEF, 16'hBEEF);
 
    $finish;
end
endmodule


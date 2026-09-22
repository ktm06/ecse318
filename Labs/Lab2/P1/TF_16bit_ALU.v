module TF_16bit_ALU();
reg [15:0] A;
reg [15:0] B;
reg [15:0] C;
reg [4:0] instruction;
reg overflow;

localparam [4:0]
    ADD = 5'b00000;
    ADDU = 5'b00001;
    SUB = 5'b00010;
    SUBU = 5'b00011;
    INC = 5'b00100;
    DEC = 5'b00101;
    AND = 5'b01000;
    OR = 5'b01001;
    XOR = 5'b01010;
    NOT = 5'b01100;
    SLL = 5'b10000;
    SRL = 5'b10001;
    SLA = 5'b10010;
    SRA = 5'b10011;


endmodule
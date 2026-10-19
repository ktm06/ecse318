`timescale 1ns/1ps

module comparison(
    input  wire [7:0] X, Y,
    input  wire       Cin,
    output wire [7:0] S,
    output wire       Co
);

    assign {Co, S} = X + Y + Cin;

endmodule

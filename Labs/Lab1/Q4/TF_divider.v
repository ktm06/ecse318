`timescale 1ns/1ps

module TF_divider();
    reg [3:0] m, d; 
    wire [3:0] q, r;
    divider uut(
        .m(m),
        .d(d),
        .q(q),
        .r(r)
    );


    initial begin
        $display("===Start===\n");
        $display ("Case 1: 7/2\n");
        d = 4'd7;
        m = 4'd2;
        #10;
        $display("Quotient: %b, Remainder:%b\n", q, r);
        $display ("Case 2: 6/2\n");
        d = 4'd6;
        m = 4'd2;
        #10;
        $display("Quotient: %b, Remainder:%b\n", q, r);
        $display ("Case 3: 9/4\n");
        d = 4'd9;
        m = 4'd4;
        #10;
        $display("Quotient: %b, Remainder:%b\n", q, r);

    end
endmodule
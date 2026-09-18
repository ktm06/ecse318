`timescale 1ns/1ps
module TF_cla();
    reg [3:0] a, b;
    reg cin;
    wire [3:0] s;

    cla uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s)
    );
    initial begin
        #1000;
        a = 4'b0100;
        b = 4'b0011;
        cin = 1'b0;
        $display ("initial: s[2] is currently %b", s[2]);
        $monitor ("first add done at %t, as s[2] is now %b", $time, s[2]);
        #1000;
        cin = 1'b1;
        $display("cin change at %t", $time);
        $monitor("time end %t: final s[3] is now %b", $time, s[3]);
    end


endmodule
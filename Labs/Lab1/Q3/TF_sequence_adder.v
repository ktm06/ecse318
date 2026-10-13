`timescale 1ns/10ps
module TF_sequence_adder();

wire [11:0] sum;
reg [7:0] O0, O1, O2, O3, O4, O5, O6, O7, O8, O9;

sequence_adder UUT(sum, O0, O1, O2, O3, O4, O5, O6, O7, O8, O9);

initial begin
    O0 = 8'd12;
    O1 = 8'd13;
    O2 = 8'd5;
    O3 = 8'd6;
    O4 = 8'd7;
    O5 = 8'd8;
    O6 = 8'd9;
    O7 = 8'd15;
    O8 = 8'd0;
    O9 = 8'd0;
    #10000;
    $display("Time = %t - Addition Sequence: %d + %d + %d + %d + %d + %d + %d + %d + %d + %d = %d", $time, O0, O1, O2, O3, O4, O5, O6, O7, O8, O9, sum);
    #500
    O0 = 8'd3;
    O1 = 8'd14;
    O2 = 8'd5;
    O3 = 8'd6;
    O4 = 8'd7;
    O5 = 8'd8;
    O6 = 8'd19;
    O7 = 8'd10;
    O8 = 8'd0;
    O9 = 8'd0;
    #1000;
    $display("Time = %t - Addition Sequence: %d + %d + %d + %d + %d + %d + %d + %d + %d + %d = %d", $time, O0, O1, O2, O3, O4, O5, O6, O7, O8, O9, sum);
    #1000;
    $finish;
end

endmodule

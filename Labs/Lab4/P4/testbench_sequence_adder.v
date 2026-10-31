`timescale 1ns/10ps
module TB_sequence_adder();

wire [11:0] sum;
reg [7:0] O0, O1, O2, O3, O4, O5, O6, O7, O8, O9;

sequence_adder UUT(sum, O0, O1, O2, O3, O4, O5, O6, O7, O8, O9);

initial begin
    O0 = 8'd1;
    O1 = 8'd2;
    O2 = 8'd3;
    O3 = 8'd4;
    O4 = 8'd5;
    O5 = 8'd6;
    O6 = 8'd7;
    O7 = 8'd8;
    O8 = 8'd9;
    O9 = 8'd10;
    #10000;
    $display("Time = %t - Addition Sequence: %d + %d + %d + %d + %d + %d + %d + %d + %d + %d = %d", $time, O0, O1, O2, O3, O4, O5, O6, O7, O8, O9, sum);
    #500
    O0 = 8'd3;
    O1 = 8'd4;
    O2 = 8'd5;
    O3 = 8'd6;
    O4 = 8'd7;
    O5 = 8'd8;
    O6 = 8'd9;
    O7 = 8'd10;
    O8 = 8'd0;
    O9 = 8'd0;
    #1000;
    $display("Time = %t - Addition Sequence: %d + %d + %d + %d + %d + %d + %d + %d + %d + %d = %d", $time, O0, O1, O2, O3, O4, O5, O6, O7, O8, O9, sum);
    #1000;
    $finish;
end

endmodule

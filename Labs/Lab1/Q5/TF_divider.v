`timescale 1ns/1ps

module TF_divider ();
    reg clk, reset, start;
    reg [3:0] divisor, dividend;
    wire [3:0] quotient, result;


    

    divider #(
        .N(4), 
        .CNT(4)) uut (
            .divisor(divisor),
            .divident(dividend),
            .q(quotient),
            .r(result),
            .clk(clk),
            .reset(reset),
            .start(start)
    );
    
    // clock
    initial begin
        clk = 0;
        
        forever begin

            #100 clk = ~clk;

        end

    end

    initial begin
        $display("===Start===\n");
        reset = 1;
        start = 0;
        #10; 
        reset = 0;
        #10;
        
        @(posedge clk); #10;
    
        $display ("Case 1: 7/2\n");
        start = 1;
        dividend = 4'd7;
        divisor = 4'd2;
        #200; start = 0;
        #1200;
        $display("Quotient: %b, Remainder:%b\n", quotient, result);
        $display ("Case 2: 6/2\n");
        start = 1;
        dividend = 4'd6;
        divisor = 4'd2;
        #200; start = 0;
        #1200;
        $display("Quotient: %b, Remainder:%b\n", quotient, result);
        $display ("Case 3: 9/4\n");
        start = 1;
        dividend = 4'd9;
        divisor = 4'd4;
        #200; start = 0;
        #1200;
        $display("Quotient: %b, Remainder:%b\n", quotient, result);

        $finish;
    end


endmodule
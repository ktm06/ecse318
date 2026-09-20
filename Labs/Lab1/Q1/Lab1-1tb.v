module tb;

    parameter bits = 4;

    reg clk, load;
    reg [bits-1:0] a, b;
    wire [bits-1:0] sum_struct, sum_behav;

    top_module       #(bits) dut_s (.clk(clk),.load(load),.a(a),.b(b),.sum(sum_struct));
    top_module_behav #(bits) dut_b (.clk(clk),.load(load),.a(a),.b(b),.sum(sum_behav));

    always #5 clk = ~clk;

    // One addition. This is a serial adder, so it takes one clock to load
    // a and b, then `bits` more clocks to shift the answer out.
    task add(input [bits-1:0] x, input [bits-1:0] y);
    begin
        a = x; b = y; load = 1;
        @(posedge clk); #1 load = 0;
        repeat (bits) @(posedge clk);
        #1;
        $display("   %2d + %2d = %2d       %b    %b", x, y, sum_struct, sum_struct, sum_behav);
    end
    endtask

    initial begin
        clk = 0; load = 0;

        $display("");
        $display("    a +  b = sum     struct  behav");
        $display("   --------------------------------");

        add( 3,  5);
        add( 1,  1);
        add( 6,  7);
        add( 9,  4);
        add(15,  1);    // overflows 4 bits, wraps to 0
        add(12,  9);    // overflows 4 bits, wraps to 5

        $display("");
        $finish;
    end

endmodule

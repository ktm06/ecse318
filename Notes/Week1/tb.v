module testbench1();
    fsm2 u1 (z, x, clk, reset);

    initial begin
        clk = 1'b0;
    end
    
    always #5 clk = ~clk;

    initial begin
        reset = 1'b1;
        #7 reset = 1'b0;
        #7 x = 2'b01;
    end

endmodule
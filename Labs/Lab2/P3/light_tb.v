`timescale 1ns/1ps

module light_tb;

    reg clk =1'b0;
    reg [15:0]errors = 16'b0;
    reg Sa = 0;
    reg Sb = 0;
    reg [15:0]i = 0;
    wire Ga,Ya,Ra,Gb,Yb,Rb;

    TrafficLightController dut(.clk(clk),.Sa(Sa),.Sb(Sb),.Ga(Ga),.Ya(Ya),.Ra(Ra),.Gb(Gb),.Yb(Yb),.Rb(Rb));

    always #10 clk = ~clk; 

    
    initial begin
        for (i = 0; i < 1000; i = i + 1)begin
            @(posedge clk)begin
                #2
                Sa = $urandom_range(1, 0);
                Sb = $urandom_range(1, 0);
                #3
                if(Ga && Gb || Ya && Yb || Ya && Gb || Ga && Yb) begin
                    errors = errors + 1;
                end
            end
        end

        $display("Errors: %0d",errors);
        $finish;

    end
    
    



endmodule
`timescale 1ns/10ps
module TB_processor();

wire clk, rst;
//reg [7:0] O0, O1, O2, O3, O4, O5, O6, O7, O8, O9;

processor UUT(clk, rst);

initial begin
    
    rst = 1;
    #20;
    rst = 0;

    uut.mem.mem[0] = 32'h10000000;
    uut.mem.mem[1] = 32'h90000000;
    uut.mem.mem[2] = 32'h50000001;
    uut.mem.mem[3] = 32'h20000001;
    #1000;
    
    #500
    
    rst = 1;
    #20;
    rst = 0;

    uut.mem.mem[0] = 32'h10000001;
    uut.mem.mem[1] = 32'h18000002;
    uut.mem.mem[2] = 32'h18000003; 
    uut.mem.mem[3] = 32'h20000001;
    uut.mem.mem[4] = 32'h40000003;
    uut.mem.mem[5] = 32'h3A00000D;
    uut.mem.mem[6] = 32'h35000008;
    uut.mem.mem[7] = 32'h50000004;
    uut.mem.mem[8] = 32'h7A000003;
    uut.mem.mem[9] = 32'h30000003;
    uut.mem.mem[10] = 32'h18000004;
    uut.mem.mem[11] = 32'h50000004;
    uut.mem.mem[12] = 32'h20000002;
    #1000;
    #500;

    rst = 1;
    #20;
    rst = 0;

    uut.mem.mem[0] = 32'h10000001;
    uut.mem.mem[1] = 32'h10000002;
    uut.mem.mem[2] = 32'h18000003; 
    uut.mem.mem[3] = 32'h18000005;
    uut.mem.mem[4] = 32'h40000002;
    uut.mem.mem[5] = 32'h3A00000D;
    uut.mem.mem[6] = 32'h70000002;
    uut.mem.mem[7] = 32'h33000009
    uut.mem.mem[8] = 32'h3600000A;
    uut.mem.mem[9] = 32'h50000001;
    uut.mem.mem[10] = 32'h50000001;
    uut.mem.mem[11] = 32'h00000011;
    uut.mem.mem[12] = 32'h20000003;

    #1000;
    #1000;
    $finish;
end

initial begin
    forever begin
        clk = 0;
        #5 clk = ~clk;
    end
end 

endmodule

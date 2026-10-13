`timescale 1ns/10ps

module TB_processor();

    reg  clk, rst;
    wire halted;

    processor UUT (.clk(clk), .rst(rst), .halted(halted));

    initial clk = 0;
    always #5 clk = ~clk;

    // opcodes
    localparam NOP=4'h0, LD=4'h1, STR=4'h2, BRA=4'h3, XOR=4'h4,
               ADD=4'h5, ROT=4'h6, SHF=4'h7, HLT=4'h8, CMP=4'h9;
    //  condition codes
    localparam CC_A=3'd0, CC_P=3'd1, CC_E=3'd2, CC_C=3'd3,
               CC_N=3'd4, CC_Z=3'd5, CC_NC=3'd6, CC_PO=3'd7;

    // {opcode, srcIsImm, 3 unused, src[11:0], dst[11:0]}
    function [31:0] enc(input [3:0] op, input imm, input [11:0] src, input [11:0] dst);
        enc = {op, imm, 3'b000, src, dst};
    endfunction

    // {BRA, cc[2:0], 13 unused, target[11:0]}   (CC in IR[27:25])
    function [31:0] encB(input [2:0] cc, input [11:0] tgt);
        encB = {BRA, cc, 13'b0, tgt};
    endfunction

    integer i;

    task clear_mem;
        begin
            for (i = 0; i < 4096; i = i + 1) UUT.memory.mem[i] = 32'b0;  // 0 = NOP
        end
    endtask

    task run_prog;
        integer cycles;
        begin
            rst = 1; @(posedge clk); @(posedge clk); #1 rst = 0;
            cycles = 0;
            while (!halted && cycles < 20000) begin
                @(posedge clk); cycles = cycles + 1;
            end
            if (!halted) $display("  TIMEOUT (program never halted)");
        end
    endtask

    // 2a 
    task test_2a(input [31:0] N);
        begin
            clear_mem;
            UUT.memory.mem[0]  = N;
            UUT.memory.mem[16] = enc(LD,  0, 12'd0, 12'd0);   // R0 = mem[0]
            UUT.memory.mem[17] = enc(CMP, 0, 12'd0, 12'd0);   // R0 = ~R0
            UUT.memory.mem[18] = enc(ADD, 1, 12'd1, 12'd0);   // R0 = R0 + 1
            UUT.memory.mem[19] = enc(STR, 0, 12'd0, 12'd1);   // mem[1] = R0
            UUT.memory.mem[20] = enc(HLT, 0, 12'd0, 12'd0);
            run_prog;
            if (UUT.memory.mem[1] == -N) $display("2a PASS  N=%0d  -N=%h", N, UUT.memory.mem[1]);
            else                         $display("2a FAIL  N=%0d  got %h expected %h", N, UUT.memory.mem[1], -N);
        end
    endtask

    // 2b
    task test_2b(input [31:0] v, input [31:0] expected);
        begin
            clear_mem;
            UUT.memory.mem[0]  = v;
            UUT.memory.mem[16] = enc(LD,  0, 12'd0, 12'd0);       // R0 = value
            UUT.memory.mem[17] = enc(LD,  1, 12'd0, 12'd1);       // R1 = 0 (count)
            UUT.memory.mem[18] = enc(LD,  1, 12'd32, 12'd2);      // R2 = 32 (loop counter)
            UUT.memory.mem[19] = enc(SHF, 0, 12'd1, 12'd0);       // LOOP: R0 >>= 1, carry = bit out
            UUT.memory.mem[20] = encB(CC_NC, 12'd22);             // carry==0 -> skip add
            UUT.memory.mem[21] = enc(ADD, 1, 12'd1, 12'd1);       // R1 += 1
            UUT.memory.mem[22] = enc(ADD, 1, 12'hFFF, 12'd2);     // SKIP: R2 -= 1
            UUT.memory.mem[23] = encB(CC_PO, 12'd19);             // R2 > 0 -> loop
            UUT.memory.mem[24] = enc(STR, 0, 12'd1, 12'd1);       // mem[1] = R1
            UUT.memory.mem[25] = enc(HLT, 0, 12'd0, 12'd0);
            run_prog;
            if (UUT.memory.mem[1] == expected) $display("2b PASS  %h -> %0d ones", v, UUT.memory.mem[1]);
            else                               $display("2b FAIL  %h got %0d expected %0d", v, UUT.memory.mem[1], expected);
        end
    endtask

    // 2c:
    task test_2c(input [31:0] a, input [31:0] b);
        begin
            clear_mem;
            UUT.memory.mem[0]  = a;
            UUT.memory.mem[1]  = b;
            UUT.memory.mem[16] = enc(LD,  0, 12'd0, 12'd0);       // R0 = A
            UUT.memory.mem[17] = enc(LD,  0, 12'd1, 12'd1);       // R1 = B
            UUT.memory.mem[18] = enc(LD,  1, 12'd0, 12'd2);       // R2 = 0 (product)
            UUT.memory.mem[19] = enc(LD,  1, 12'd5, 12'd3);       // R3 = 5 (counter)
            UUT.memory.mem[20] = enc(SHF, 0, 12'd1, 12'd1);       // LOOP: R1 >>= 1, carry = low bit of B
            UUT.memory.mem[21] = encB(CC_NC, 12'd23);             // bit 0 -> skip add
            UUT.memory.mem[22] = enc(ADD, 0, 12'd0, 12'd2);       // R2 += R0
            UUT.memory.mem[23] = enc(SHF, 0, 12'hFFF, 12'd0);     // SKIP: R0 <<= 1
            UUT.memory.mem[24] = enc(ADD, 1, 12'hFFF, 12'd3);     // R3 -= 1
            UUT.memory.mem[25] = encB(CC_PO, 12'd20);             // R3 > 0 -> loop
            UUT.memory.mem[26] = enc(STR, 0, 12'd2, 12'd2);       // mem[2] = R2
            UUT.memory.mem[27] = enc(HLT, 0, 12'd0, 12'd0);
            run_prog;
            if (UUT.memory.mem[2] == a*b) $display("2c PASS  %0d x %0d = %0d", a, b, UUT.memory.mem[2]);
            else                          $display("2c FAIL  %0d x %0d got %0d expected %0d", a, b, UUT.memory.mem[2], a*b);
        end
    endtask

    initial begin
        rst = 1;
        #1;
        test_2a(32'd6);
        test_2a(32'd1);
        test_2a(32'd0);

        test_2b(32'h00000000, 0);
        test_2b(32'hFFFFFFFF, 32);
        test_2b(32'hA5A5A5A5, 16);

        test_2c(0, 0);
        test_2c(5, 7);
        test_2c(31, 31);
        test_2c(13, 29);

        $finish;
    end

endmodule

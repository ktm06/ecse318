module registerFile (clk, write_en, read_addr1, read_addr2, write_addr,
                     read_data1, read_data2, write_data);
    output [31:0] read_data1, read_data2;
    input  [31:0] write_data;
    input  [3:0]  write_addr, read_addr1, read_addr2;
    input         clk, write_en;

    reg [31:0] regs [15:0];

    assign read_data1 = regs[read_addr1];
    assign read_data2 = regs[read_addr2];

    always @(posedge clk)
        if (write_en) regs[write_addr] <= write_data;
endmodule

module ramModel (clk, addr, write_data, read_data, en);
    output [31:0] read_data;
    input  [31:0] write_data;
    input  [11:0] addr;
    input         clk, en;

    reg [31:0] mem [4095:0];

    assign read_data = mem[addr];

    always @(posedge clk)
        if (en) mem[addr] <= write_data;
endmodule

module ALU (op1, op2, opcode, cnt, result, carry);
    output reg [31:0] result;
    output reg        carry;
    input  [31:0]     op1, op2;
    input  [11:0]     cnt;
    input  [2:0]      opcode;

    integer n; 

    always @(*) begin
        n      = $signed(cnt);
        result = 32'b0;  
        carry  = 1'b0;
        case (opcode)
            3'b001: {carry, result} = op1 + op2;
            3'b010: result = op1 ^ op2;
            3'b011: result = ~op2;
            3'b100: begin                                   
                if (n > 0) begin                            
                    result = (op1 >> n) | (op1 << (32 - n));
                    carry  = result[31];                    
                end else if (n < 0) begin                   
                    result = (op1 << -n) | (op1 >> (32 + n));
                    carry  = result[0];
                end else
                    result = op1;
            end
            3'b101: begin                                   
                if (n > 0) begin
                    result = op1 >> n;
                    carry  = op1[n-1];                      
                end else if (n < 0) begin
                    result = op1 << -n;
                    carry  = op1[32+n];                     
                end else
                    result = op1;
            end
            default: ;
        endcase
    end
endmodule

module controlUnit (clk, rst, ir, psr,
                    reg_write, mem_write, pc_load, pc_increment, ir_load,
                    psr_en, psr_clear, force_c0, is_ld, is_str, fetch, halted, alu_op);
    input         clk, rst;
    input  [31:0] ir;
    input  [4:0]  psr;
    output reg    reg_write, mem_write, pc_load, psr_en, psr_clear, force_c0, is_ld, is_str;
    output reg [2:0] alu_op;
    output        pc_increment, ir_load, fetch, halted;

    localparam FETCH = 2'd0, EXEC = 2'd1, HALT = 2'd2;
    reg [1:0] state;
    wire [3:0] op = ir[31:28];

    always @(posedge clk) begin
        if (rst) state <= FETCH;
        else case (state)
            FETCH:   state <= EXEC;
            EXEC:    state <= (op == 4'h8) ? HALT : FETCH;
            default: state <= HALT;
        endcase
    end

    assign fetch        = (state == FETCH);
    assign ir_load      = fetch;
    assign pc_increment = fetch;
    assign halted       = (state == HALT);

    always @(*) begin
        reg_write = 0; mem_write = 0; pc_load = 0;
        psr_en = 0; psr_clear = 0; force_c0 = 0;
        is_ld = 0; is_str = 0; alu_op = 3'b000;

        if (state == EXEC) begin
            case (op)
                4'h0: ;                                                   
                4'h1: begin reg_write=1; is_ld=1; psr_en=1; force_c0=1; end         
                4'h2: begin mem_write=1; is_str=1; psr_clear=1; end                 
                4'h3: pc_load = condition(ir[27:25], psr);                          
                4'h4: begin reg_write=1; alu_op=3'b010; psr_en=1; force_c0=1; end   
                4'h5: begin reg_write=1; alu_op=3'b001; psr_en=1 end               
                4'h6: begin reg_write=1; alu_op=3'b100; psr_en=1; end               
                4'h7: begin reg_write=1; alu_op=3'b101; psr_en=1; end               
                4'h8: ;                                                  
                4'h9: begin reg_write=1; alu_op=3'b011; psr_en=1; force_c0=1; end   
                default: ;
            endcase
        end
    end

    function condition (input [2:0] cc, input [4:0] p);
        case (cc)
            3'd0: condition = 1'b1;               
            3'd1: condition = p[1];               
            3'd2: condition = p[2];               
            3'd3: condition = p[0];               
            3'd4: condition = p[3];               
            3'd5: condition = p[4];               
            3'd6: condition = ~p[0];              
            3'd7: condition = ~p[3] & ~p[4];      
            default: condition = 1'b0;
        endcase
    endfunction
endmodule

module instructionRegister (clk, ir_load, ir_in, ir_out);
    output reg [31:0] ir_out;
    input  [31:0]     ir_in;
    input             clk, ir_load;

    always @(posedge clk)
        if (ir_load) ir_out <= ir_in;
endmodule

module programCounter (clk, rst, pc_load, pc_increment, load_addr, pc_out);
    output reg [11:0] pc_out;
    input             clk, rst, pc_load, pc_increment;
    input  [11:0]     load_addr;

    always @(posedge clk) begin
        if (rst)               pc_out <= 12'd16;
        else if (pc_load)      pc_out <= load_addr;
        else if (pc_increment) pc_out <= pc_out + 1;
    end
endmodule

module PSR (clk, rst, psr_en, psr_clear, force_c0, flags_in, psr_out);
    output reg [4:0] psr_out;
    input  [4:0]     flags_in;
    input            clk, rst, psr_en, psr_clear, force_c0;

    always @(posedge clk) begin
        if (rst)            psr_out <= 5'b0;
        else if (psr_clear) psr_out <= 5'b0;
        else if (psr_en)    psr_out <= {flags_in[4:1], force_c0 ? 1'b0 : flags_in[0]};
    end
endmodule

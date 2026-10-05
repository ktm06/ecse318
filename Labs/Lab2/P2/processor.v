module registerFile (clk, rst, write_en, read_addr1, read_addr2, write_addr, read_data1, read_data2, write_data);

output [31:0] read_data1, read_data2;
input [31:0] write_data;
input [11:0] write_addr;
input [3:0] read_addr1, read_addr2;
input clk, rst , write_en;

reg [31:0] regs [15:0];

assign read_data1 = regs[read_addr1];
assign read_data2 = regs[read_addr2];

genvar i;
generate
    always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 16; i++) begin
            regs[i] <= 32'b0;
        end
    end else if (write_en) begin
        regs[write_addr] <= write_data;
    end
end
endgenerate

endmodule

module ramModel (clk, rst, addr, write_data, read_data, en);
    output [31:0] read_data;
    input [31:0] write_data;
    input [11:0] addr;
    input clk, rst, en;

    reg [31:0] mem [4095:0];

    assign read_data = mem[addr];

genvar i;
generate
    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 4096; i++) begin
                mem[i] <= 32'b0;
            end
        end else if (en) begin
            mem[addr] <= write_data;
        end
end
endgenerate
    
endmodule

module ALU (op1, op2, opcode, cnt, psr, result);
    output [31:0] result;
    output [4:0] psr; 
    input [31:0] op1, op2;
    input [11:0] cnt;
    input [2:0] opcode;
    
    always @(*) begin
        case (opcode)
            3'b001: begin
                {psr[0], result} = op1 + op2;
            end
            3'b010: begin
                psr[0] = 0;
                result = op1 ^ op2;
            end
            3'b011: begin
                psr[0] = 0;
                result = ~op1;
            end
            3'b100: begin
                psr[0] = cnt > 0 ? op1[cnt-1] : op1[31 - (cnt-1)];
                result = {op1[cnt-1:0], op1[31:cnt]};
            end
            3'b101: begin
                psr[0] = cnt > 0 ? op1[cnt-1] : op1[31 - (cnt-1)];
                result = op1 >> cnt;
            end
            default: begin
                psr[0] = 0;
                result = 0;
            end
        endcase

        psr[1] = ~(^result);
        psr[2] = result[0] == 1'b0;
        psr[3] = result[31];
        psr[4] = result == 0;
    end
    
endmodule

module controlUnit (ir, psr, reg_write, alu_op, mem_write, pc_increment, pc_load);
output reg_write, mem_write, pc_increment, pc_load;
output [2:0] alu_op;
input [31:0] ir;
input [4:0] psr 

always @(*) begin
    alu_op = 3'b000;
    reg_write = 0;
    mem_write = 0;
    pc_increment = 1;
    pc_load = 0;

    case (ir[31:28])
        5'b0000: begin
            pc_increment = 1;
        end
        5'b0001: begin
            reg_write = 1;
            pc_increment = 1;
            psr[0] = 1'b0;
        end
        5'b0010: begin
            mem_write = 1;
            pc_increment = 1;
            psr[0] = 1'b0;
        end
        5'b0011: begin
            if (conditionCode(ir[27:25], psr)) begin
                pc_load = 1;
            end else begin
                pc_increment = 1;
            end
        end
        5'b0100: begin
            reg_write = 1;
            alu_op = 3'b010;
            pc_increment = 1;
        end
        5'b0101: begin
            reg_write = 1;
            alu_op = 3'b001;
            pc_increment = 1;
        end
        5'b0110: begin
            reg_write = 1;
            alu_op = 3'b100;
            pc_increment = 1;
        end
        5'b0111: begin
            reg_write = 1;
            alu_op = 3'b101;
            pc_increment = 1;
        end
        5'b1000: begin
            pc_increment = 0;
        end
        5'b1001: begin
            reg_write = 1;
            alu_op = 3'b011;
            pc_increment = 1;
        end
    endcase
    
end

    function reg conditionCode (input [2:0] cc, input [4:0] psr);
    
    case (cc)
        3'b000: conditionCode = 1;
        3'b001: conditionCode = psr[1];
        3'b010: conditionCode = psr[2];
        3'b011: conditionCode = psr[0];
        3'b100: conditionCode = psr[3];
        3'b101: conditionCode = psr[4];
        3'b110: conditionCode = !psr[0];
        3'b111: conditionCode = (!psr[3]) && (!psr[4]);
    endcase
    endfunction
endmodule

module instructionRegister (clk, ir_in, ir_out);
output [31:0] ir_out;
input [31:0] ir_in;
input clk;

always @(posedge clk) begin
    ir_out <= ir_in;
end
endmodule

module programCounter (clk, rst, pc_load, pc_increment, load_addr, pc_out);
input clk, rst, pc_load, pc_increment;
input [11:0] load_addr;
output [11:0] pc_out;

always @(posedge clk) begin
    if (rst) begin
        pc_out <= 12'b0;
    end else if (pc_load) begin
        pc_out <= load_addr;
    end else if (pc_increment) begin
        pc_out <= pc_out + 1;
    end else begin
        pc_out <= pc_out;
    end
end
    
endmodule

module psr (clk, rst, psr_update, psr_out);
output [4:0] psr_out;
input [4:0] psr_update;
input clk, rst;

always @(posedge clk) begin
    if (rst) begin
        psr_out <= 5'b0;
    end else begin
        psr_out <= psr_update;
    end
end
    
endmodule
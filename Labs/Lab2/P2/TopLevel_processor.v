module processor(clk, rst);

input clk, rst;

wire reg_write, mem_write, pc_increment, pc_load;
wire [2:0] alu_op;
wire [31:0] ir_out;
wire [4:0] psr_flags;
wire [4:0] psr_update;

wire [31:0] data1, data2, data_out, alu_result;
wire [11:0] pc, addr;

reg [31:0] mem [4095:0]; 

always @(*) begin
    case (ir[31:28])
        5'b0001: begin
            addr = (ir[27]) ? ir[23:12]: ir[11:0];   
        end
        5'b0010: begin
            src = (ir[26]) ? ir[23:12]: ir[11:0];           
        end
        5'b0100: begin
            src = (ir[26]) ? ir[23:12]: ir[11:0];            
        end
        5'b0101: begin
            src = (ir[26]) ? ir[23:12]: ir[11:0];           
        end
        5'b0101: begin
            src = (ir[26]) ? ir[23:12]: ir[11:0];           
        end
        default: 
        addr = ir[11:0];
        src = ir[11:0];
    endcase
end

register_file register(.clk(clk), .rst(rst), .write_en(reg_write), .read_addr1(ir_out[23:12]), .read_addr2(src), .write_addr(addr), .read_data1(data1), .read_data2(data2), .write_data(alu_result));
ramModel memory(.clk(clk), .rst(rst), .addr(pc), .write_data(data_out), .read_data(data1), .en(mem_write));
ALU alu_op(.op1(data1), .op2(data2), .opcode(alu_op), .cnt(ir_out[23:12]), .psr(psr_update), .result(alu_result));
controlUnit ctrl_sigs(.ir(ir_out), .psr(psr_flags), .reg_write(reg_write), .alu_op(alu_op), .mem_write(mem_write), .pc_increment(pc_increment), .pc_load(pc_load));
instructionRegister ir_load(.clk(clk), .ir_in(data_out), .ir_out(ir_out));
programCounter pro_addr(.clk(clk), .rst(rst), .pc_load(pc_load), .pc_increment(pc_increment), .load_addr(ir[11:0]), .pc_out(pc));
psr psr(.clk(clk) .rst(rst), psr_update.(psr_update), psr_out.(psr_flags));


endmodule


//Also, for the top-level processor module, I want to understand how you were able to determine what the indices were for the two addresses that would be read for the register file since the instruction register format, there is the opcode, cc, source type, destination type, source address, shift/rotate count, and destination address?
module processor(clk, rst);

input clk, rst;

wire reg_write, mem_write, pc_increment, pc_load;
wire [2:0] alu_op;
wire [31:0] ir_out;
wire [4:0] psr_flags;
wire [4:0] psr_update;

wire [31:0] data1, data2, data_out, alu_result;
wire [11:0] pc,

reg [11:0] addr, src;
reg [31:0] mem [4095:0]; 

always @(*) begin
    case (ir_out[31:28])
        5'b0001: begin
            addr <= (ir_out[27]) ? ir_out[23:12]: ir_out[11:0];   
        end
        5'b0010: begin
            src <= (ir_out[26]) ? ir_out[23:12]: ir_out[11:0];           
        end
        5'b0100: begin
            src <= (ir_out[26]) ? ir_out[23:12]: ir_out[11:0];            
        end
        5'b0101: begin
            src <= (ir_out[26]) ? ir_out[23:12]: ir_out[11:0];           
        end
        5'b1001: begin
            src <= (ir_out[26]) ? ir_out[23:12]: ir_out[11:0];           
        end
        default: begin
            addr <= ir_out[11:0];
            src <= ir_out[11:0];
        end
    endcase
end

register_file register(.clk(clk), .rst(rst), .write_en(reg_write), .read_addr1(ir_out[23:12]), .read_addr2(src), .write_addr(addr), .read_data1(data1), .read_data2(data2), .write_data(alu_result));
ramModel memory(.clk(clk), .rst(rst), .addr(pc), .write_data(data_out), .read_data(data1), .en(mem_write));
ALU alu_op(.op1(data1), .op2(data2), .opcode(alu_op), .cnt(ir_out[23:12]), .psr(psr_update), .result(alu_result));
controlUnit ctrl_sigs(.ir(ir_out), .psr(psr_flags), .reg_write(reg_write), .alu_op(alu_op), .mem_write(mem_write), .pc_increment(pc_increment), .pc_load(pc_load));
instructionRegister ir_load(.clk(clk), .ir_in(data_out), .ir_out(ir_out));
programCounter pro_addr(.clk(clk), .rst(rst), .pc_load(pc_load), .pc_increment(pc_increment), .load_addr(ir_out[11:0]), .pc_out(pc));
psr psr(.clk(clk) .rst(rst), .psr_update.(psr_update), .psr_out.(psr_flags));


endmodule
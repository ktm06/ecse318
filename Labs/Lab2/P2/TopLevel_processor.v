module processor (clk, rst, halted);
    input  clk, rst;
    output halted;

    wire reg_write, mem_write, pc_load, pc_increment, ir_load;
    wire psr_en, psr_clear, force_c0, is_ld, is_str, fetch;
    wire [2:0] alu_op;

    wire [31:0] ir_out, data1, data2, ram_rdata, alu_result, imm, srcval, ld_val, wb_data;
    wire [11:0] pc, ram_addr;
    wire [4:0]  psr_flags, flags_in;
    wire        alu_carry;

    assign imm      = {{20{ir_out[23]}}, ir_out[23:12]};            
    assign srcval   = ir_out[27] ? imm : data2;                      
    assign ram_addr = fetch ? pc : (is_str ? ir_out[11:0] : ir_out[23:12]);
    assign ld_val   = ir_out[26] ? imm : ram_rdata;                  
    assign wb_data  = is_ld ? ld_val : alu_result;                   

    assign flags_in = { (wb_data == 32'b0), wb_data[31], ~wb_data[0], ~(^wb_data), alu_carry };

    registerFile register (.clk(clk), .write_en(reg_write), .read_addr1(ir_out[3:0]),  .read_addr2(ir_out[15:12]), .write_addr(ir_out[3:0]), .read_data1(data1), .read_data2(data2), .write_data(wb_data));

    ramModel memory (.clk(clk), .addr(ram_addr), .write_data(srcval), .read_data(ram_rdata), .en(mem_write));

    ALU alu (.op1(data1), .op2(srcval), .opcode(alu_op), .cnt(ir_out[23:12]), .result(alu_result), .carry(alu_carry));

    controlUnit ctrl (.clk(clk), .rst(rst), .ir(ir_out), .psr(psr_flags), .reg_write(reg_write), .mem_write(mem_write), .pc_load(pc_load), .pc_increment(pc_increment), .ir_load(ir_load), .psr_en(psr_en), .psr_clear(psr_clear), .force_c0(force_c0), .is_ld(is_ld), .is_str(is_str), .fetch(fetch), .halted(halted), .alu_op(alu_op));

    instructionRegister ir_reg (.clk(clk), .ir_load(ir_load), .ir_in(ram_rdata), .ir_out(ir_out));

    programCounter pc_reg (.clk(clk), .rst(rst), .pc_load(pc_load), .pc_increment(pc_increment), .load_addr(ir_out[11:0]), .pc_out(pc));

    PSR psr_reg (.clk(clk), .rst(rst), .psr_en(psr_en), .psr_clear(psr_clear), .force_c0(force_c0), .flags_in(flags_in), .psr_out(psr_flags));
endmodule

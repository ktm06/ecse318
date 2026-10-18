module RxFIFO(
    input wire PSEL,
    input wire PWRITE,
    output wire [7:0] PRDATA,
    input wire CLEAR_B,
    input wire PCLK,
    input wire RxWrite,
    output SSPRXINTR,
    input [7:0] RxData
);
reg [7:0] memory [0:3];
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
reg RxWrite_d;

assign SSPRXINTR = (wr_ptr[2] != rd_ptr[2]) && (wr_ptr[1:0] == rd_ptr[1:0]);
assign PRDATA = (PSEL && ~PWRITE) ? memory[rd_ptr[1:0]] : 8'b0;

always @(posedge PCLK) begin
    if (~CLEAR_B) begin
        wr_ptr <= 3'b000;
        rd_ptr <= 3'b000;
        RxWrite_d <= 1'b0;
    end else begin
        RxWrite_d <= RxWrite;
        if (RxWrite && ~RxWrite_d && ~SSPRXINTR) begin
            memory[wr_ptr[1:0]] <= RxData;
            wr_ptr <= wr_ptr + 1;
        end
        if (PSEL && ~PWRITE) begin
            if (wr_ptr != rd_ptr) begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end
end

endmodule
module TxFIFO(
    input wire PSEL,
    input wire PWRITE,
    input wire [7:0] PWDATA,
    input wire CLEAR_B,
    input wire PCLK,
    input wire TxRead,
    output TxValid,
    output SSPTXINTR,
    output [7:0] TxData
);

reg [7:0] memory [0:3];
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
reg TxRead_d;

assign TxValid = (wr_ptr != rd_ptr);
assign SSPTXINTR = (wr_ptr[2] != rd_ptr[2]) && (wr_ptr[1:0] == rd_ptr[1:0]);
assign TxData = memory[rd_ptr[1:0]];

always @(posedge PCLK) begin
    if (~CLEAR_B) begin
        wr_ptr <= 3'b000;
        rd_ptr <= 3'b000;
        TxRead_d <= 1'b0;
    end else begin
        TxRead_d <= TxRead;
        if (PSEL && PWRITE) begin
            if (~SSPTXINTR) begin
                memory[wr_ptr[1:0]] <= PWDATA;
                wr_ptr <= wr_ptr + 1;
            end
        end
        if (TxRead && ~TxRead_d && TxValid) begin
            rd_ptr <= rd_ptr + 1;
        end
    end
end

endmodule
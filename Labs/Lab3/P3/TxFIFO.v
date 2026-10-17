module TxFIFO(
    input wire PSEL,
    input wire PWRITE,
    input wire [7:0] PWDATA,
    input wire CLEAR_B,
    input wire PCLK,
    input wire signals*,
    output SSPTXINTR,
    output TxData[7:0],
);

reg [7:0] memory [0:3]; // memory buffer
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;

always @(posedge PCLK) begin
    if (PWRITE) begin


end

endmodule
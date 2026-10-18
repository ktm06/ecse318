module ssp(
    input wire PCLK,
    input wire CLEAR_B,
    input wire PSEL,
    input wire PWRITE,
    input wire [7:0] PWDATA,
    input wire SSPCLKIN,
    input wire SSPFSSIN,
    input wire SSPRXD,
    output wire [7:0] PRDATA,
    output wire SSPOE_B,
    output wire SSPTXD,
    output wire SSPCLKOUT,
    output wire SSPFSSOUT,
    output wire SSPTXINTR,
    output wire SSPRXINTR
);

wire [7:0] TxData;
wire TxValid;
wire TxRead;
wire [7:0] RxData;
wire RxWrite;

TxFIFO txfifo(
    .PSEL(PSEL),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .CLEAR_B(CLEAR_B),
    .PCLK(PCLK),
    .TxRead(TxRead),
    .TxValid(TxValid),
    .SSPTXINTR(SSPTXINTR),
    .TxData(TxData)
);

RxFIFO rxfifo(
    .PSEL(PSEL),
    .PWRITE(PWRITE),
    .PRDATA(PRDATA),
    .CLEAR_B(CLEAR_B),
    .PCLK(PCLK),
    .RxWrite(RxWrite),
    .SSPRXINTR(SSPRXINTR),
    .RxData(RxData)
);

TXRXLogic txrxlogic(
    .PCLK(PCLK),
    .CLEAR_B(CLEAR_B),
    .TxData(TxData),
    .TxValid(TxValid),
    .TxRead(TxRead),
    .RxData(RxData),
    .RxWrite(RxWrite),
    .SSPOE_B(SSPOE_B),
    .SSPTXD(SSPTXD),
    .SSPFSSOUT(SSPFSSOUT),
    .SSPCLKOUT(SSPCLKOUT),
    .SSPCLKIN(SSPCLKIN),
    .SSPFSSIN(SSPFSSIN),
    .SSPRXD(SSPRXD)
);

endmodule
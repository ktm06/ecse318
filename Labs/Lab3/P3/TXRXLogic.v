module TXRXLogic(
    input wire PCLK,
    input wire CLEAR_B,
    input wire [7:0] TxData,
    input wire TxValid,
    output reg TxRead,
    output reg [7:0] RxData,
    output reg RxWrite,
    output reg SSPOE_B,
    output reg SSPTXD,
    output reg SSPFSSOUT,
    output reg SSPCLKOUT,
    input wire SSPCLKIN,
    input wire SSPFSSIN,
    input wire SSPRXD
);

reg [7:0] tx_shift;
reg [3:0] tx_count;
reg tx_busy;
reg [7:0] rx_shift;
reg [3:0] rx_count;

always @(posedge PCLK) begin
    if (~CLEAR_B) begin
        SSPCLKOUT <= 1'b0;
        SSPFSSOUT <= 1'b0;
        SSPTXD <= 1'b0;
        SSPOE_B <= 1'b1;
        TxRead <= 1'b0;
        tx_count <= 4'd0;
        tx_busy <= 1'b0;
    end else begin
        SSPCLKOUT <= ~SSPCLKOUT;
        TxRead <= 1'b0;
        if (~SSPCLKOUT) begin
            SSPFSSOUT <= 1'b0;
            if (tx_count != 0) begin
                SSPTXD <= tx_shift[7];
                tx_shift <= {tx_shift[6:0], 1'b0};
                tx_count <= tx_count - 1;
                tx_busy <= 1'b1;
            end else begin
                SSPTXD <= 1'b0;
                tx_busy <= 1'b0;
            end
            if ((tx_count == 0 || tx_count == 1) && TxValid) begin
                tx_shift <= TxData;
                tx_count <= 4'd8;
                SSPFSSOUT <= 1'b1;
                TxRead <= 1'b1;
            end
        end else begin
            SSPOE_B <= ~(tx_busy || tx_count != 0);
        end
    end
end

always @(negedge SSPCLKIN or negedge CLEAR_B) begin
    if (~CLEAR_B) begin
        rx_count <= 4'd0;
        RxWrite <= 1'b0;
    end else begin
        RxWrite <= 1'b0;
        if (rx_count != 0) begin
            rx_shift <= {rx_shift[6:0], SSPRXD};
            rx_count <= rx_count - 1;
            if (rx_count == 1) begin
                RxData <= {rx_shift[6:0], SSPRXD};
                RxWrite <= 1'b1;
            end
        end
        if (SSPFSSIN) begin
            rx_count <= 4'd8;
        end
    end
end

endmodule
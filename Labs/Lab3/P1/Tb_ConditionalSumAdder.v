`timescale 1ns/1ps

module tb_ConditionalSumAdder;
    reg  [7:0] X, Y;
    reg        Cin;
    wire [7:0] S;
    wire       Co;
    integer    i, j, k, errors;

    ConditionalSumAdder dut (.X(X), .Y(Y), .Cin(Cin), .S(S), .Co(Co));

    initial begin
        errors = 0;

        //example
        X = 8'b01101110; Y = 8'b01010101; Cin = 0; #1;
        $display("Example: %b + %b = %b%b (%0d)", X, Y, Co, S, {Co, S});

        //check all input combinations
        for (k = 0; k < 2; k = k + 1)
            for (i = 0; i < 256; i = i + 1)
                for (j = 0; j < 256; j = j + 1) begin
                    X = i; Y = j; Cin = k; #1;
                    if ({Co, S} !== i + j + k) begin
                        errors = errors + 1;
                        if (errors <= 10)
                            $display("FAIL: %0d + %0d + %0d -> %0d", i, j, k, {Co, S});
                    end
                end

        if (errors == 0) $display("all 131072 cases correct");
        else             $display("%0d errors", errors);
        $finish;
    end
endmodule
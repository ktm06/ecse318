`timescale 1ns/1ps

module tb_Comparison;
    reg  [7:0] X, Y;
    reg        Cin;
    wire [7:0] S, S_csa;
    wire       Co, Co_csa;
    integer    i, j, k, errors;

    comparison          u_ref (.X(X), .Y(Y), .Cin(Cin), .S(S),     .Co(Co));
    ConditionalSumAdder csa (.X(X), .Y(Y), .Cin(Cin), .S(S_csa), .Co(Co_csa));

    initial begin
        errors = 0;

        //example
        X = 8'b01101110; Y = 8'b01010101; Cin = 0; #1;
        $display("Example: %b + %b = %b%b (%0d)", X, Y, Co, S, {Co, S});

        //check all input combinations against X+Y+Cin and the conditional sum adder
        for (k = 0; k < 2; k = k + 1)
            for (i = 0; i < 256; i = i + 1)
                for (j = 0; j < 256; j = j + 1) begin
                    X = i; Y = j; Cin = k; #1;
                    if ({Co, S} !== i + j + k || {Co, S} !== {Co_csa, S_csa}) begin
                        errors = errors + 1;
                        if (errors <= 10)
                            $display("FAIL: %0d + %0d + %0d -> %0d (csa %0d)", i, j, k, {Co, S}, {Co_csa, S_csa});
                    end
                end

        if (errors == 0) $display("all 131072 cases correct, comparison == ConditionalSumAdder");
        else             $display("%0d errors", errors);
        $finish;
    end
endmodule

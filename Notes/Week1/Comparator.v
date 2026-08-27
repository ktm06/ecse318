module comp(ALTB, AEQB, A, B);
    output ALTB, AEQB;
    input [3:0] A, B;
    reg ALTB, AEQB;

    always @( A or B ) begin
        if (A < B) begin 
            ALTB = 1;
            AEQB = 0;
        end
        else if (A == B) begin 
            ALTB = 0;
            AEQB = 1;
        end
        else begin 
            ALTB = 0;
            AEQB = 0;
        end
    end

endmodule

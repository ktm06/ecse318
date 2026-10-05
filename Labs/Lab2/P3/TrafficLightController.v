module TrafficLightController(
    input clk,
    input Sa,Sb,
    output reg Ga,Ya,Ra,
    output reg Gb,Yb,Rb
);

reg [1:0]state = 2'd0;
reg [2:0]count = 3'd0;
reg error =0;

function isError (
    input Ga, Ya, Ra, Gb, Yb, Rb
);
    isError = Ga && Gb || Ya && Yb || Ya && Gb || Ga && Yb;
endfunction





always @(posedge clk)begin
    if(!isError(Ga, Ya, Ra, Gb, Yb, Rb) && !error)begin
        if (state == 3'd0)begin //Greenlight on A
            
            state = 3'd0;

            Ga = 1;
            Ya = 0;
            Ra = 0;

            Gb = 0;
            Yb = 0;
            Rb = 1;

            if (count == 3'd6 && Sb == 1)begin //change to a green light if it has been 6 ticks
                state = 3'd1;
                count = 3'd0;
            end else if (count == 3'd6)begin
                count = 3'd5; // get count stuck at 6 with the +1 at the bottom
            end

        end else if (state == 3'd1)begin// Transition From Green on A to Green on B

            state = 3'd1;

            Ga = 0;
            Ya = 1;
            Ra = 0;

            Gb = 0;
            Yb = 0;
            Rb = 1;

            if (count == 3'd2)begin 

                state = 3'd2;
                count = 3'd0;

            end

        end else if (state == 3'd2)begin // Green on b Red on A

            state = 3'd2;

            Ga = 0;
            Ya = 0;
            Ra = 1;

            Gb = 1;
            Yb = 0;
            Rb = 0;

            if (count == 3'd5 && Sb == 1 && Sa == 0)begin

                count = 0;

            end else if (count == 3'd5)begin

                state = 3'd3;
                count =0;

            end


        end else if (state == 3'd3)begin //Transition from green on b to green on a
            
            state = 3'd3;

            Ga = 0;
            Ya = 0;
            Ra = 1;

            Gb = 0;
            Yb = 1;
            Rb = 0;

            if (count == 3'd2)begin 

                state = 3'd0;
                count = 3'd0;

            end
        end
    end else begin // ERROR SEQUENCE
        error = 1;
        if (count & 1'b1)begin
            count = 3'b111;

            Ga = 0;
            Ya = 0;
            Ra = 1;

            Gb = 0;
            Yb = 0;
            Rb = 1;
        end else begin
            count = 0;

            Ga = 0;
            Ya = 0;
            Ra = 0;

            Gb = 0;
            Yb = 0;
            Rb = 0;
        end

    end

    count = count + 1;
    
end





endmodule
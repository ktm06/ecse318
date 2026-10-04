`default_nettype none 

module top_module #(parameter bits = 8) (input wire clk, input wire load, input wire [bits-1:0]a, input wire [bits-1:0]b, output wire [bits-1:0]sum);
    wire [bits-1:0] a_q, b_q;
    wire s, cout, carry, carrybar, nload, carry_d;
    shiftreg #(bits) addend (.clk(clk),.load(load),.sin(1'b0),.pin(a),.q(a_q));
    shiftreg #(bits) augend (.clk(clk),.load(load),.sin(1'b0),.pin(b),.q(b_q));

    fulladder adder (.a(a_q[0]),.b(b_q[0]),.cin(carry),.sum(s),.cout(cout));

    // carry cleared while loading
    not n1 (nload, load);
    and a1 (carry_d, cout, nload);
    dff_u carryreg (.clk(clk),.d(carry_d),.q(carry),.qbar(carrybar));

    shiftreg #(bits) result (.clk(clk),.load(1'b0),.sin(s),.pin({bits{1'b0}}),.q(sum));

endmodule


module shiftreg #(parameter bits = 8)(input wire clk, input wire load, input wire sin, input wire[bits-1:0] pin, output wire[bits-1:0] q);
    wire [bits:0] chain;
    assign chain = {sin, q};

    generate
        genvar i;
        wire [bits-1:0]d;
        wire [bits-1:0]regbar;
        for(i=0; i < bits; i = i + 1) begin : cells
            mux2 muxy(.a(pin[i]),.b(chain[i+1]),.s(load),.y(d[i]));
            dff_u flippy(.clk(clk),.d(d[i]),.q(q[i]),.qbar(regbar[i]));
        end
    endgenerate

endmodule


module mux2 (input wire a, input wire b, input wire s, output wire y);

    wire sn,t1,t2;
    not n1(sn,s);
    and a1(t1,a,s);
    and a2(t2,b,sn);
    or o1(y,t1,t2);

endmodule



module dff_u (input wire clk, input wire d, output wire q, output wire qbar);

    wire w1,w2,w3,w4;
    not n1(w1,clk);
    not n2(w2,w1);

    dlatch_nand l1 (.d(d),.e(w1),.q(w3),.qbar(w4));
    dlatch_nand l2 (.d(w3),.e(w2), .q(q),.qbar(qbar));

endmodule

module dlatch_nand (input wire d, input wire e, output wire q, output wire qbar);

    wire w1,w2,w3;

    nand na1 (w1,d);
    nand na2 (w2,d,e);
    nand na3 (w3,e,w1);
    nand na4 (q, w2,qbar);
    nand na5 (qbar,w3,q);

endmodule

module fulladder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);

    //sum
    wire i1;

    xor n1 (i1 , a, b);
    xor n2 (sum, i1, cin);

    //carry
    wire i2,i3,i4,i5;

    and a1(i2,a,b);
    and a2(i3,a,cin);
    and a3(i4,b,cin);
    or o1(i5,i2,i3);
    or o2(cout,i4,i5);

endmodule


`default_nettype wire

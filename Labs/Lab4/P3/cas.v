module cas(input a, b, m, cin,
            output s, cout);

    wire b_control;
    // m is for control (xor)
    assign b_control = m ^ b;
    fa u_fa (.a(a), 
                .b(b_control), 
                .cin(cin), 
                .sum(s), 
                .cout(cout));


endmodule
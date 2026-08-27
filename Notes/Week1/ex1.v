module ckt(o, x, y, z);
    input x, y, z;
    output o;

    nand A (L1, x, y),
        B (L2, y, z);
        C (o, L1, L2);
endmodule
TF_ksa();
reg [15:0] A;
reg [15:0] B;
reg cin;
reg [15:0] C;
reg cout;
    ksa #(N=16) uut 
    (
        .A(A),
        .B(B),
        .cin(cin),
        .C(C),
        .cout(cout)
    );

initial begin
    A = 'd0;
    B = 'd0;
    cin = 'd0;
    #100
    A = 16'd0;
    B = 16'd5;
    #100

    $display("0 + 5 = %d", C);


end
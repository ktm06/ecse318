entity fulladder is
    port (x, y, cin: in bit; -- inputs
        sum cout: out bit);

end fulladder

architecture rtl of fulladder is
begin
    sum  <= x xor y xor cin;
    cout <= (x and y) or (x and cin) or (y and cin);
end rtl;
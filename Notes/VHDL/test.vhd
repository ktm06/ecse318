component HA 
    port (
        I1 I2: in bit;
        carry: out bit;
        sum: out bit;
        )
end component


component OR 
    port (
        I1, I2 : in bit;
        O : out bit;
    )
    signal a, b, c : bit;
    
    begin
        u1 : HA port map(x, y, a, b);
        u2 : HA (b, )
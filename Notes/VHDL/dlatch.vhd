entity dlat is
    port (d, clk: in bit; q : out bit);
end dlat;
architecture basic of dlat is
begin
    latbehav: process is 
    begin
        if clk = '1' then
            q <=d;
        end if;
        wait on clk, d;
    end process latbehav;
        end architecture basic;
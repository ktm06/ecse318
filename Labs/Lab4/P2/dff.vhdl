library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity dff is
    port (
        q : out std_logic;
        d, clk : in std_logic
    );
end dff;

architecture Behavioral of dff is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            q <= d;
        end if;                     
    end process;
end Behavioral;

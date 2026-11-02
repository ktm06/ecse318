library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_ram is
    port (
        clk : in std_logic;
        index : in std_logic_vector(7 downto 0);
        we : in std_logic;
        din : in std_logic_vector(31 downto 0);
        dout : out std_logic_vector(31 downto 0)
    );
end data_ram;

architecture behav of data_ram is
    type ram_t is array (0 to 255) of std_logic_vector(31 downto 0);
    signal ram : ram_t;
    
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(to_integer(unsigned(index))) <= din after 1 ns;
            end if;
        end if;
    end process;

    process (index, ram)
    begin
        if is_x(index) then
            dout <= (others => 'X') after 1 ns;
        else
            dout <= ram(to_integer(unsigned(index))) after 1 ns;
        end if;
    end process;

end behav;
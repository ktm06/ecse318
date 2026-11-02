library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tag_ram is
    port (
        clk : in std_logic;
        reset : in std_logic;
        index : in std_logic_vector(7 downto 0);
        tag : in std_logic_vector(5 downto 0);
        we : in std_logic;
        hit : out std_logic
    );
end tag_ram;

architecture behav of tag_ram is

    type tag_array_t is array (0 to 255) of std_logic_vector(5 downto 0);

    signal tags : tag_array_t;
    signal valid : std_logic_vector(255 downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                valid <= (others => '0') after 1 ns;
            else
                if we = '1' then
                    tags(to_integer(unsigned(index))) <= tag after 1 ns;
                    valid(to_integer(unsigned(index))) <= '1' after 1 ns;
                end if;
            end if;
        end if;
    end process;

    process (index, tag, tags, valid)
    begin
        if is_x(index) then
            hit <= '0' after 1 ns;
        else
            if valid(to_integer(unsigned(index))) = '1' and tags(to_integer(unsigned(index))) = tag then
                hit <= '1' after 1 ns;
            else
                hit <= '0' after 1 ns;
            end if;
        end if;
    end process;

end behav;
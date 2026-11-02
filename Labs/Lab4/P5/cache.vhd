library ieee;
use ieee.std_logic_1164.all;

entity cache is
    port (
        Pstrobe : in std_logic;
        Prw : in std_logic;
        Paddr : in std_logic_vector(15 downto 0);
        Pdata : inout std_logic_vector(31 downto 0);
        Pready : out std_logic;
        Sysstrobe : out std_logic;
        Sysrw : out std_logic;
        Sysaddress : out std_logic_vector(15 downto 0);
        Sysdata : inout std_logic_vector(31 downto 0);
        clk : in std_logic;
        reset : in std_logic
    );
end cache;

architecture structural of cache is
    signal hit : std_logic;
    signal ram_we : std_logic;
    signal fill : std_logic;
    signal ram_din : std_logic_vector(31 downto 0);
    signal ram_dout : std_logic_vector(31 downto 0);

begin
    ram_din <= Sysdata after 1 ns when fill = '1' else Pdata after 1 ns;

    u_tag : entity work.tag_ram
        port map (
            clk => clk,
            reset => reset,
            index => Paddr(9 downto 2),
            tag => Paddr(15 downto 10),
            we => ram_we,
            hit => hit
        );

    u_ram : entity work.data_ram
        port map (
            clk => clk,
            index => Paddr(9 downto 2),
            we => ram_we,
            din => ram_din,
            dout => ram_dout
        );

    u_ctrl : entity work.cache_control
        port map (
            Pstrobe => Pstrobe,
            Prw => Prw,
            Paddr => Paddr,
            Pdata => Pdata,
            Pready => Pready,
            Sysstrobe => Sysstrobe,
            Sysrw => Sysrw,
            Sysaddress => Sysaddress,
            Sysdata => Sysdata,
            hit => hit,
            ram_dout => ram_dout,
            ram_we => ram_we,
            fill => fill,
            clk => clk,
            reset => reset
        );

end structural;
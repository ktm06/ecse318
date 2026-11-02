library ieee;
use ieee.std_logic_1164.all;

entity divider is
    port (
        m : in std_logic_vector(3 downto 0);
        d : in std_logic_vector(3 downto 0);
        q : out std_logic_vector(3 downto 0);
        r : out std_logic_vector(3 downto 0)
    );
end entity divider;

architecture structural of divider is
    component cas is
        port (
            a, b, m, cin : in std_logic;
            s, cout : out std_logic
        );
    end component;

    component cas_row is
        port (
            m : in std_logic_vector(3 downto 0);
            d : in std_logic_vector(3 downto 0);
            control : in std_logic;
            s : out std_logic_vector(3 downto 0);
            q : out std_logic
        );
    end component;

    type vec4_array is array (0 to 3) of std_logic_vector(3 downto 0);

    signal row_in : vec4_array;
    signal row_out : vec4_array;
    signal top : std_logic_vector(3 downto 0);
    signal c4 : std_logic_vector(3 downto 0);
    signal qb : std_logic_vector(3 downto 0);
    signal ctrl : std_logic_vector(3 downto 0);
    signal m_fix : std_logic_vector(3 downto 0);
begin
    q <= qb(0) & qb(1) & qb(2) & qb(3);

    gen_rows : for i in 0 to 3 generate
        first_row : if i = 0 generate
            row_in(i) <= "000" & d(3);
            top(i) <= '0';
            ctrl(i) <= '1';
        end generate first_row;

        other_rows : if i > 0 generate
            row_in(i) <= row_out(i-1)(2 downto 0) & d(3-i);
            top(i) <= row_out(i-1)(3);
            ctrl(i) <= qb(i-1);
        end generate other_rows;

        row : cas_row
            port map (
                m => m,
                d => row_in(i),
                control => ctrl(i),
                s => row_out(i),
                q => c4(i)
            );

        sign_cell : cas
            port map (
                a => top(i),
                b => '0',
                m => ctrl(i),
                cin => c4(i),
                s => open,
                cout => qb(i)
            );
    end generate gen_rows;

    m_fix <= "0000" when qb(3) = '1' else m;

    fix : cas_row
        port map (
            m => m_fix,
            d => row_out(3),
            control => '0',
            s => r,
            q => open
        );
end architecture structural;
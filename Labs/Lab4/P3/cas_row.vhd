library ieee;
use ieee.std_logic_1164.all;

entity cas_row is
    port (
        m : in std_logic_vector(3 downto 0);
        d : in std_logic_vector(3 downto 0);
        control : in std_logic;
        s : out std_logic_vector(3 downto 0);
        q : out std_logic
    );
end entity cas_row;

architecture structural of cas_row is
    component cas is
        port (
            a, b, m, cin : in std_logic;
            s, cout : out std_logic
        );
    end component;

    signal cout : std_logic_vector(4 downto 0);
begin
    cout(0) <= control;
    q <= cout(4);

    gen_cas : for i in 0 to 3 generate
        add_sub : cas
            port map (
                a => d(i),
                b => m(i),
                m => control,
                cin => cout(i),
                s => s(i),
                cout => cout(i+1)
            );
    end generate gen_cas;
end architecture structural;
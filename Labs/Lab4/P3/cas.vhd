library ieee;
use ieee.std_logic_1164.all;

entity cas is
    port (
        a, b, m, cin : in std_logic;
        s, cout : out std_logic
    );
end entity cas;

architecture structural of cas is
    component fa is
        port (
            a, b, cin : in std_logic;
            cout, sum : out std_logic
        );
    end component;

    signal b_control : std_logic;
begin
    b_control <= m xor b;

    u_fa : fa
        port map (
            a => a,
            b => b_control,
            cin => cin,
            sum => s,
            cout => cout
        );
end architecture structural;
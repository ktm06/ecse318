library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity TF_divider is
end entity TF_divider;

architecture sim of TF_divider is
    component divider is
        port (
            m : in std_logic_vector(3 downto 0);
            d : in std_logic_vector(3 downto 0);
            q : out std_logic_vector(3 downto 0);
            r : out std_logic_vector(3 downto 0)
        );
    end component;

    signal m, d : std_logic_vector(3 downto 0);
    signal q, r : std_logic_vector(3 downto 0);

    procedure display(msg : in string) is
        variable l : line;
    begin
        write(l, msg);
        writeline(output, l);
        writeline(output, l);
    end procedure;

    function bin(v : std_logic_vector) return string is
        variable s : string(1 to v'length);
        variable img : string(1 to 3);
        variable k : integer := 1;
    begin
        for i in v'range loop
            img := std_logic'image(v(i));
            s(k) := img(2);
            k := k + 1;
        end loop;
        return s;
    end function;
begin
    uut : divider
        port map (
            m => m,
            d => d,
            q => q,
            r => r
        );

    process
    begin
        display("===Start===");
        display("Case 1: 7/2");
        d <= std_logic_vector(to_unsigned(7, 4));
        m <= std_logic_vector(to_unsigned(2, 4));
        wait for 10 ns;
        display("Quotient: " & bin(q) & ", Remainder:" & bin(r));
        display("Case 2: 6/2");
        d <= std_logic_vector(to_unsigned(6, 4));
        m <= std_logic_vector(to_unsigned(2, 4));
        wait for 10 ns;
        display("Quotient: " & bin(q) & ", Remainder:" & bin(r));
        display("Case 3: 9/4");
        d <= std_logic_vector(to_unsigned(9, 4));
        m <= std_logic_vector(to_unsigned(4, 4));
        wait for 10 ns;
        display("Quotient: " & bin(q) & ", Remainder:" & bin(r));
        wait;
    end process;
end architecture sim;
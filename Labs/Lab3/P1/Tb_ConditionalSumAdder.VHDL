library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ConditionalSumAdder is
end entity;

architecture sim of tb_ConditionalSumAdder is
    signal X, Y : std_logic_vector(7 downto 0);
    signal Cin  : std_logic;
    signal S    : std_logic_vector(7 downto 0);
    signal Co   : std_logic;
begin
    dut : entity work.ConditionalSumAdder port map (X => X, Y => Y, Cin => Cin, S => S, Co => Co);

    process
        variable errors : natural := 0;
        variable got    : natural;
    begin
        X <= "01101110"; Y <= "01010101"; Cin <= '0';
        wait for 1 ns;
        report "Example: 110 + 85 = " & integer'image(to_integer(unsigned(Co & S)));

        for k in 0 to 1 loop
            for i in 0 to 255 loop
                for j in 0 to 255 loop
                    X <= std_logic_vector(to_unsigned(i, 8));
                    Y <= std_logic_vector(to_unsigned(j, 8));
                    if k = 1 then Cin <= '1'; else Cin <= '0'; end if;
                    wait for 1 ns;
                    got := to_integer(unsigned(Co & S));
                    if got /= i + j + k then
                        errors := errors + 1;
                        if errors <= 10 then
                            report "FAIL: " & integer'image(i) & " + " & integer'image(j)
                                & " + " & integer'image(k) & " -> " & integer'image(got)
                                severity error;
                        end if;
                    end if;
                end loop;
            end loop;
        end loop;

        if errors = 0 then
            report "all 131072 cases correct";
        else
            report integer'image(errors) & " errors" severity failure;
        end if;
        wait;
    end process;
end architecture;
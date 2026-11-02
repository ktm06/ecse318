library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity MultiplierVHDL_tb is
end MultiplierVHDL_tb;

architecture sim of MultiplierVHDL_tb is

signal A, B : std_logic_vector(3 downto 0) := "0000";
signal FinalProduct : std_logic_vector(7 downto 0);
signal load, done : std_logic := '0';
signal clk : std_logic := '0';
signal finished : boolean := false;

begin

dut : entity work.MultiplierVHDL
port map (A => A, B => B, clk => clk, load => load, done => done, FinalProduct => FinalProduct);

clk <= not clk after 5 ns when not finished;

process

    variable cycles : integer;
    variable fails : integer := 0;

    procedure multiply (x, y : in integer) is
    begin
        A <= std_logic_vector(to_unsigned(x, 4));
        B <= std_logic_vector(to_unsigned(y, 4));
        load <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        load <= '0';
        cycles := 0;
        while done /= '1' loop
            wait until rising_edge(clk);
            wait for 1 ns;
            cycles := cycles + 1;
        end loop;
        if to_integer(unsigned(FinalProduct)) /= x * y or cycles /= 4 then
            fails := fails + 1;
            report integer'image(x) & " * " & integer'image(y) & " gave "
                & integer'image(to_integer(unsigned(FinalProduct))) severity error;
        end if;
    end procedure;

begin

    multiply(2, 4);
    report "2 * 4 = " & integer'image(to_integer(unsigned(FinalProduct)));
    wait for 20 ns;
    multiply(15, 3);
    report "15 * 3 = " & integer'image(to_integer(unsigned(FinalProduct)));
    wait for 20 ns;

    for x in 0 to 15 loop
        for y in 0 to 15 loop
            multiply(x, y);
        end loop;
    end loop;

    report "failures: " & integer'image(fails);
    finished <= true;
    wait;

end process;

end sim;

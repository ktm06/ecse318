library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_parallel_multiplication is
end TB_parallel_multiplication;

architecture Simulation of TB_parallel_multiplication is

    signal product : std_logic_vector(7 downto 0);
    signal multiplier : std_logic_vector(3 downto 0);
    signal multiplicand : std_logic_vector(3 downto 0);

    component parallel_multiplication is

        port (
            product : out std_logic_vector(7 downto 0);
            multiplicand : in std_logic_vector(3 downto 0);
            multiplier : in std_logic_vector(3 downto 0)
        );

    end component;

begin

    UUT : parallel_multiplication
        port map (
            product => product,
            multiplicand => multiplicand,
            multiplier => multiplier
        );

    process begin

        multiplicand <= (others => '0');
        multiplier <= (others => '0');

        -- Test case 1: 2 * 4
        multiplicand <= "0010";
        multiplier <= "0100";
        wait for 10000 ns;
        report "Multiplication of 2 and 4 = " & integer'image(to_integer(unsigned(product))) severity note;

        -- Test case 2: 15 * 3
        wait for 500 ns;
        multiplicand <= "1111";
        multiplier <= "0011";
        wait for 1000 ns;
        report "Multiplication of 15 and 3 = " & integer'image(to_integer(unsigned(product))) severity note;

        wait for 1000 ns;
        wait;
    end process;

end Simulation;
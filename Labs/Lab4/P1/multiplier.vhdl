library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity parallel_multiplication is

    port (
        product : out  std_logic_vector(7 downto 0);
        multiplicand : in  std_logic_vector(3 downto 0);
        multiplier : in std_logic_vector(3 downto 0)
    );

end parallel_multiplication;

architecture Behavioral of parallel_multiplication is

    type four_2Darray_type is array (0 to 3) of std_logic_vector(3 downto 0);
    type five_2Darray_type is array (0 to 3) of std_logic_vector(4 downto 0);

    signal c_out : four_2Darray_type;
    signal s_in : five_2Darray_type;
    signal CSA_array_row0 : std_logic_vector(3 downto 0);
    signal CSA_array_row1 : std_logic_vector(3 downto 0);
    signal CSA_array_row2 : std_logic_vector(3 downto 0);
    signal CSA_array_row3 : std_logic_vector(3 downto 0);
    signal product_cin : std_logic_vector(4 downto 0);

begin

    CSA_array_row0 <= (multiplier'range => multiplicand(0)) and (multiplier);
    CSA_array_row1 <= (multiplier'range => multiplicand(1)) and (multiplier); -- (multiplicand(2 downto 0) & multiplicand(3)) and multiplier;
    CSA_array_row2 <= (multiplier'range => multiplicand(2)) and (multiplier); --(multiplicand(1 downto 0) & multiplicand(3 downto 2)) and multiplier;
    CSA_array_row3 <= (multiplier'range => multiplicand(3)) and (multiplier); -- (multiplicand(0) & multiplicand(3 downto 1)) and multiplier;
    product_cin(0) <= '0';

    gen_CSA_array1: for i in 0 to 3 generate
    U1 : entity work.full_adder
        port map (
            s => s_in(0)(i), c_out => c_out(0)(i), a => CSA_array_row0(i), b => '0', c => '0'
        );
    end generate gen_CSA_array1;
    s_in(0)(4) <= '0';

    gen_CSA_array2: for i in 0 to 3 generate
    U2 : entity work.full_adder
        port map (
            s => s_in(1)(i), c_out => c_out(1)(i), a => CSA_array_row1(i), b => s_in(0)(i + 1), c => c_out(0)(i)
        );
    end generate gen_CSA_array2;
    s_in(1)(4) <= '0';

    gen_CSA_array3: for i in 0 to 3 generate
    U3 : entity work.full_adder
        port map (
            s => s_in(2)(i), c_out => c_out(2)(i), a => CSA_array_row2(i), b => s_in(1)(i + 1), c => c_out(1)(i)
        );
    end generate gen_CSA_array3;
    s_in(2)(4) <= '0';

    gen_CSA_array4: for i in 0 to 3 generate
    U4 : entity work.full_adder
        port map (
            s => s_in(3)(i), c_out => c_out(3)(i), a => CSA_array_row3(i), b => s_in(2)(i + 1), c => c_out(2)(i)
        );
    end generate gen_CSA_array4;
    s_in(3)(4) <= '0';

    product(0) <= s_in(0)(0);
    product(1) <= s_in(1)(0);
    product(2) <= s_in(2)(0);
    product(3) <= s_in(3)(0);

    gen_CPA: for i in 4 to 7 generate
    U5 : entity work.full_adder
        port map (
            s => product(i), c_out => product_cin(i - 3), a => s_in(3)(i - 3), b => c_out(3)(i - 4), c => product_cin(i - 4)
        );
    end generate gen_CPA; 

end Behavioral;
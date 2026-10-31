library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CSA_stage is
    port (
        s : out std_logic;
        c_out : out std_logic;
        a : in std_logic;
        b : in std_logic;
        c : in std_logic
    );
end CSA_stage;

architecture Behavioral of CSA_stage is

    signal p, g : std_logic;

begin

    p <= a xor b;
    g <= a and b;
    s <= p xor c;
    c_out <= g or (c and p);

end Behavioral;

entity sequence_adder is
    port (
        sum : out std_logic_vector(11 downto 0);
        O0 : in std_logic_vector(7 downto 0);
        O1 : in std_logic_vector(7 downto 0);
        O2 : in std_logic_vector(7 downto 0);
        O3 : in std_logic_vector(7 downto 0);
        O4 : in std_logic_vector(7 downto 0);
        O5 : in std_logic_vector(7 downto 0);
        O6 : in std_logic_vector(7 downto 0);
        O7 : in std_logic_vector(7 downto 0);
        O8 : in std_logic_vector(7 downto 0);
        O9 : in std_logic_vector(7 downto 0)
    );
end sequence_adder;

architecture Behavioral of sequence_adder is

    type two_array_type is array (0 to 1) of std_logic_vector(12 downto 0);
    type three_array_13_type is array (0 to 2) of std_logic_vector(12 downto 0);
    type three_array_12_type is array (0 to 2) of std_logic_vector(11 downto 0);
    type four_array_type is array (0 to 3) of std_logic_vector(11 downto 0);
    type five_array_type is array (0 to 4) of std_logic_vector(11 downto 0);
    type seven_array_type is array (0 to 6) of std_logic_vector(11 downto 0);

    signal carry_12, carry_13 : std_logic_vector(12 downto 0);
    signal carry_11, carry_10 : two_array_type;
    signal carry_9 : three_array_13_type;
    signal CSA_11 : three_array_12_type;
    signal CSA_10 : four_array_type;
    signal CSA_9 : five_array_type;
    signal CSA_8 : seven_array_type;
    signal CSA_12 : std_logic_vector(11 downto 0);
    signal W0, W1, W2, W3, W4, W5, W6, W7, W8, W9 : std_logic_vector(11 downto 0);

begin

    W0 <= "0000" & O0;
    W1 <= "0000" & O1;
    W2 <= "0000" & O2;
    W3 <= "0000" & O3;
    W4 <= "0000" & O4;
    W5 <= "0000" & O5;
    W6 <= "0000" & O6;
    W7 <= "0000" & O7;
    W8 <= "0000" & O8;
    W9 <= "0000" & O9;
    
    -- 10 operands -> 7 operands
    carry_9(0)(0) <= '0';
    carry_9(1)(0) <= '0';
    carry_9(2)(0) <= '0';

    gen_block: for i in 0 to 11 generate
    U1_1 : entity work.CSA_stage
        port map (
            s => CSA_8(0)(i), c_out => carry_9(0)(i + 1), a => W0(i), b => W1(i), c => W2(i)
        );
    U1_2 : entity work.CSA_stage
        port map (
            s => CSA_8(1)(i), c_out => carry_9(1)(i + 1), a => W3(i), b => W4(i), c => W5(i)
        );
    U1_3 : entity work.CSA_stage
        port map (
            s => CSA_8(2)(i), c_out => carry_9(2)(i + 1), a => W6(i), b => W7(i), c => W8(i)
        );
    end generate gen_block;
    
    CSA_8(3) <= carry_9(0)(11 downto 0);
    CSA_8(4) <= carry_9(1)(11 downto 0);
    CSA_8(5) <= carry_9(2)(11 downto 0);
    CSA_8(6) <= W9;
    
    -- 7 operands -> 5 operands
    carry_10(0)(0) <= '0';
    carry_10(1)(0) <= '0';
    
    gen_block: for i in 0 to 11 generate
    U2_1 : entity work.CSA_stage
        port map (
            s => CSA_9(0)(i), c_out => carry_10(0)(i + 1), a => CSA_8(0)(i), b => CSA_8(1)(i), c => CSA_8(2)(i)
        );
    U2_2 : entity work.CSA_stage
        port map (
            s => CSA_9(1)(i), c_out => carry_10(1)(i + 1), a => CSA_8(3)(i), b => CSA_8(4)(i), c => CSA_8(5)(i)
        );
    end generate gen_block;
    
    CSA_9(2) <= carry_10(0)(11 downto 0);
    CSA_9(3) <= carry_10(1)(11 downto 0);
    CSA_9(4) <= CSA_8(6);

    -- 5 operands -> 4 operands
    carry_11(0)(0) <= '0';
    carry_11(1)(0) <= '0';

    gen_block: for i in 0 to 11 generate
    U3_1 : entity work.CSA_stage
        port map (
            s => CSA_10(0)(i), c_out => carry_11(0)(i + 1), a => CSA_9(0)(i), b => CSA_9(1)(i), c => CSA_9(2)(i)
        );
    U3_2 : entity work.CSA_stage
        port map (
            s => CSA_10(1)(i), c_out => carry_11(1)(i + 1), a => CSA_9(3)(i), b => CSA_9(4)(i), c => '0'
        );
    end generate gen_block;
    
    CSA_10(2) <= carry_11(0)(11 downto 0);
    CSA_10(3) <= carry_11(1)(11 downto 0);

    -- 4 operands -> 3 operands
    carry_12(0) <= '0';

    gen_block: for i in 0 to 11 generate
    U4_1 : entity work.CSA_stage
        port map (
        s => CSA_11(0)(i), c_out => carry_12(1)(i + 1), a => CSA_10(0)(i), b => CSA_10(1)(i), c => CSA_10(2)(i)
      );
    end generate gen_block;

    CSA_11[1] <= carry_12(11 downto 0);
    CSA_11(2) <= CSA_10(3);

    -- 3 operands -> 2 operands
    carry_13(0) <= '0';

    gen_block: for i in 0 to 11 generate
    U5_1 : entity work.CSA_stage
        port map (
        s => CSA_12(i), c_out => carry_13(i + 1), a => CSA_11(0)(i), b => CSA_11(1)(i), c => CSA_11(2)(i)
      );
    end generate gen_block;

    sum <= std_logic_vector(unsigned(CSA_12) + unsigned(carry_13));

end Behavioral;
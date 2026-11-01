library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity MultiplierVHDL is
    port (
        A, B : in std_logic_vector(3 downto 0);
        clk, load : in std_logic;
        done : out std_logic;
        FinalProduct: out std_logic_vector(7 downto 0)
    );
end MultiplierVHDL;

architecture Behavioral of MultiplierVHDL is

signal Pout,Aout,Bout,sum,addend : std_logic_vector(3 downto 0);
signal Pd,Ad,Bd : std_logic_vector(3 downto 0);
signal carry : std_logic_vector(4 downto 0);
signal Tout,Td : std_logic_vector(4 downto 0);
signal CarryOut,en : std_logic;

begin

carry(0) <= '0';

gen: for i in 0 to 3 generate

    FAi : entity work.adder
    port map (s => sum(i), c_out => carry(i+1), a => Pout(i), b => addend(i), c => carry(i));

    addend(i) <= Bout(i) and Aout(0);

end generate gen;

Pd <= "0000" when load = '1' else carry(4) & sum(3 downto 1) when en = '1' else Pout;
Ad <= A when load = '1' else sum(0) & Aout(3 downto 1) when en = '1' else Aout;
Bd <= B when load = '1' else Bout;

gen_regs: for i in 0 to 3 generate

    U_P : entity work.dff
    port map (q => Pout(i), d => Pd(i), clk => clk);

    U_A : entity work.dff
    port map (q => Aout(i), d => Ad(i), clk => clk);

    U_B : entity work.dff
    port map (q => Bout(i), d => Bd(i), clk => clk);

end generate gen_regs;

U_C : entity work.dff
port map (q => CarryOut, d => '0', clk => clk);

Td <= "00001" when load = '1' else Tout(3 downto 0) & '0' when en = '1' else Tout;
en <= not Tout(4);
done <= Tout(4);

gen_count: for i in 0 to 4 generate

    U_T : entity work.dff
    port map (q => Tout(i), d => Td(i), clk => clk);

end generate gen_count;

FinalProduct <= Pout & Aout;

end Behavioral;

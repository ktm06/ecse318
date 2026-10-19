library ieee;
use ieee.std_logic_1164.all;

entity Leaf is
    port (
        X, Y   : in  std_logic;
        S0, S1 : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of Leaf is
begin
    S0 <= (X and Y) & (X xor Y);
    S1 <= (X or Y)  & not (X xor Y);
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity Merge is
    generic ( WIDTH : positive := 1 );
    port (
        L0, L1, H0, H1 : in  std_logic_vector(WIDTH downto 0);
        S0, S1         : out std_logic_vector(2*WIDTH downto 0)
    );
end entity;

architecture rtl of Merge is
begin
    S0 <= H1 & L0(WIDTH-1 downto 0) when L0(WIDTH) = '1' else
        H0 & L0(WIDTH-1 downto 0);
    S1 <= H1 & L1(WIDTH-1 downto 0) when L1(WIDTH) = '1' else
        H0 & L1(WIDTH-1 downto 0);
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity Resolve is
    generic ( WIDTH : positive := 1 );
    port (
        cin    : in  std_logic;
        S0, S1 : in  std_logic_vector(WIDTH downto 0);
        S      : out std_logic_vector(WIDTH downto 0)
    );
end entity;

architecture rtl of Resolve is
begin
    S <= S1 when cin = '1' else S0;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity ConditionalSumAdder is
    port (
        X, Y : in  std_logic_vector(7 downto 0);
        Cin  : in  std_logic;
        S    : out std_logic_vector(7 downto 0);
        Co   : out std_logic
    );
end entity;

architecture structural of ConditionalSumAdder is
    signal c1, c2, c4 : std_logic;
    signal r0, r1     : std_logic_vector(1 downto 0);
    signal l1_0, l1_1, l2_0, l2_1, l3_0, l3_1 : std_logic_vector(1 downto 0);
    signal l4_0, l4_1, l5_0, l5_1, l6_0, l6_1, l7_0, l7_1 : std_logic_vector(1 downto 0);
    signal m32_0, m32_1, r32 : std_logic_vector(2 downto 0);
    signal m54_0, m54_1, m76_0, m76_1 : std_logic_vector(2 downto 0);
    signal m74_0, m74_1, r74 : std_logic_vector(4 downto 0);
begin
    -- Bit 0
    r0(0) <= X(0) xor Y(0) xor Cin;
    r0(1) <= (X(0) and Y(0)) or (Cin and (X(0) xor Y(0)));
    c1    <= r0(1);
    S(0)  <= r0(0);

    -- Bit 1
    u_l1 : entity work.Leaf port map (X => X(1), Y => Y(1), S0 => l1_0, S1 => l1_1);
    u_res1 : entity work.Resolve generic map (WIDTH => 1)
        port map (cin => c1, S0 => l1_0, S1 => l1_1, S => r1);
    c2   <= r1(1);
    S(1) <= r1(0);

    -- Bits 3:2
    u_l2 : entity work.Leaf port map (X => X(2), Y => Y(2), S0 => l2_0, S1 => l2_1);
    u_l3 : entity work.Leaf port map (X => X(3), Y => Y(3), S0 => l3_0, S1 => l3_1);
    u_m32 : entity work.Merge generic map (WIDTH => 1)
        port map (L0 => l2_0, L1 => l2_1, H0 => l3_0, H1 => l3_1, S0 => m32_0, S1 => m32_1);
    u_res32 : entity work.Resolve generic map (WIDTH => 2)
        port map (cin => c2, S0 => m32_0, S1 => m32_1, S => r32);
    c4          <= r32(2);
    S(3 downto 2) <= r32(1 downto 0);

    -- Bits 7:4
    u_l4 : entity work.Leaf port map (X => X(4), Y => Y(4), S0 => l4_0, S1 => l4_1);
    u_l5 : entity work.Leaf port map (X => X(5), Y => Y(5), S0 => l5_0, S1 => l5_1);
    u_l6 : entity work.Leaf port map (X => X(6), Y => Y(6), S0 => l6_0, S1 => l6_1);
    u_l7 : entity work.Leaf port map (X => X(7), Y => Y(7), S0 => l7_0, S1 => l7_1);
    u_m54 : entity work.Merge generic map (WIDTH => 1)
        port map (L0 => l4_0, L1 => l4_1, H0 => l5_0, H1 => l5_1, S0 => m54_0, S1 => m54_1);
    u_m76 : entity work.Merge generic map (WIDTH => 1)
        port map (L0 => l6_0, L1 => l6_1, H0 => l7_0, H1 => l7_1, S0 => m76_0, S1 => m76_1);
    u_m74 : entity work.Merge generic map (WIDTH => 2)
        port map (L0 => m54_0, L1 => m54_1, H0 => m76_0, H1 => m76_1, S0 => m74_0, S1 => m74_1);
    u_res74 : entity work.Resolve generic map (WIDTH => 4)
        port map (cin => c4, S0 => m74_0, S1 => m74_1, S => r74);
    Co            <= r74(4);
    S(7 downto 4) <= r74(3 downto 0);
end architecture;
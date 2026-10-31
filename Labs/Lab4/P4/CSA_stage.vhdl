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
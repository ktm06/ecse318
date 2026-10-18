library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity divider is
    generic (
        N : integer := 4;    
        CNT : integer := 4   
    );
    port (
        divisor  : in  std_logic_vector(N-1 downto 0);
        dividend : in  std_logic_vector(N-1 downto 0);
        q        : out std_logic_vector(N-1 downto 0);
        r_out    : out std_logic_vector(N-1 downto 0);
        clk      : in  std_logic;
        reset    : in  std_logic;
        start    : in  std_logic
    );
end divider;

architecture Behavioral of divider is
    
    signal D, M : std_logic_vector(N-1 downto 0); 
    signal R, Mwide, R_N, sum : std_logic_vector(N downto 0);  
    signal control, sign : std_logic;                  

    signal count : integer range 0 to CNT+1;
begin

    sign <= R(N);
    control <= not sign;

    R_N <= R when (count = 1) else R(N-1 downto 0) & D(N-1);
    Mwide <= '0' & M;

    sum <= std_logic_vector(unsigned(R_N) + unsigned(Mwide)) when (control = '0') else
           std_logic_vector(unsigned(R_N) - unsigned(Mwide));

    q <= D;
    r_out <= R(N-1 downto 0);

    process(clk, reset) begin
        if rising_edge(reset) then
            R <= (others => '0');
            D <= (others => '0');
            M <= (others => '0');
            count <= 0;
        elsif rising_edge(clk) then
            if start = '1' then
                D <= dividend;
                M <= divisor;
                R <= (others => '0');
                count <= CNT + 1;
            else
                if count > 1 then
                    R <= sum;
                    if count = CNT + 1 then
                        D <= D(N-2 downto 0) & '0';
                    else
                        D <= D(N-2 downto 1) & not sign & '0';
                    end if;
                    count <= count - 1;
                elsif count = 1 then
                    D(0) <= not sign;
                    if sign = '1' then R <= sum; end if;
                    count <= 0;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
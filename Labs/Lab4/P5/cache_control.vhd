library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity cache_control is
    port (
        Pstrobe : in std_logic;
        Prw : in std_logic;
        Paddr : in std_logic_vector(15 downto 0);
        Pdata : inout std_logic_vector(31 downto 0);
        Pready : out std_logic;
        Sysstrobe : out std_logic;
        Sysrw : out std_logic;
        Sysaddress : out std_logic_vector(15 downto 0);
        Sysdata : inout std_logic_vector(31 downto 0);
        hit : in std_logic;
        ram_dout : in std_logic_vector(31 downto 0);
        ram_we : out std_logic;
        fill : out std_logic;
        clk : in std_logic;
        reset : in std_logic
    );
end cache_control;
 
architecture rtl of cache_control is
    type State_t is (IDLE, RD_WAIT, RD_FILL, WR_WAIT, RESP);
    attribute enum_encoding : string;
    attribute enum_encoding of State_t : type is "00001 00010 00100 01000 10000";
    signal state : State_t;
    signal cnt : unsigned(2 downto 0);
    signal pdata_q : std_logic_vector(31 downto 0);
    signal pdata_oe : std_logic;
    signal sysdata_q : std_logic_vector(31 downto 0);
    signal sysdata_oe : std_logic;
 
begin
    Pdata <= pdata_q after 1 ns when pdata_oe = '1' else (others => 'Z') after 1 ns;
    Sysdata <= sysdata_q after 1 ns when sysdata_oe = '1' else (others => 'Z') after 1 ns;
    ram_we <= '1' after 1 ns when (state = IDLE and Pstrobe = '1' and Prw = '0') or state = RD_FILL else '0' after 1 ns;
    fill <= '1' after 1 ns when state = RD_FILL else '0' after 1 ns;
 
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE after 1 ns;
                cnt <= "000" after 1 ns;
                Pready <= '0' after 1 ns;
                pdata_oe <= '0' after 1 ns;
                sysdata_oe <= '0' after 1 ns;
                Sysstrobe <= '0' after 1 ns;
                Sysrw <= '0' after 1 ns;
                Sysaddress <= (others => 'Z') after 1 ns;
            else
                case state is
                    when IDLE =>
                        if Pstrobe = '1' then
                            if Prw = '1' and hit = '1' then
                                pdata_q <= ram_dout after 1 ns;
                                pdata_oe <= '1' after 1 ns;
                                Pready <= '1' after 1 ns;
                                state <= RESP after 1 ns;
                            else
                                Sysstrobe <= '1' after 1 ns;
                                Sysrw <= Prw after 1 ns;
                                Sysaddress <= Paddr(15 downto 2) & "00" after 1 ns;
                                cnt <= "100" after 1 ns;
                                if Prw = '1' then
                                    state <= RD_WAIT after 1 ns;
                                else
                                    sysdata_q <= Pdata after 1 ns;
                                    sysdata_oe <= '1' after 1 ns;
                                    state <= WR_WAIT after 1 ns;
                                end if;
                            end if;
                        end if;
                    when RD_WAIT =>
                        Sysstrobe <= '0' after 1 ns;
                        if cnt = 0 then
                            state <= RD_FILL after 1 ns;
                        else
                            cnt <= cnt - 1 after 1 ns;
                        end if;
                    when RD_FILL =>
                        pdata_q <= Sysdata after 1 ns;
                        pdata_oe <= '1' after 1 ns;
                        Pready <= '1' after 1 ns;
                        Sysrw <= '0' after 1 ns;
                        Sysaddress <= (others => 'Z') after 1 ns;
                        state <= RESP after 1 ns;
                    when WR_WAIT =>
                        Sysstrobe <= '0' after 1 ns;
                        if cnt = 0 then
                            sysdata_oe <= '0' after 1 ns;
                            Sysaddress <= (others => 'Z') after 1 ns;
                            Pready <= '1' after 1 ns;
                            state <= RESP after 1 ns;
                        else
                            cnt <= cnt - 1 after 1 ns;
                        end if;
                    when RESP =>
                        Pready <= '0' after 1 ns;
                        pdata_oe <= '0' after 1 ns;
                        state <= IDLE after 1 ns;
                    when others =>
                        state <= IDLE after 1 ns;
                end case;
            end if;
        end if;
    end process;
 
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity main_memory is
    port (
        clk : in std_logic;
        Sysstrobe : in std_logic;
        Sysrw : in std_logic;
        Sysaddress : in std_logic_vector(15 downto 0);
        Sysdata : inout std_logic_vector(31 downto 0)
    );
end main_memory;
 
architecture behav of main_memory is
    type mem_t is array (0 to 16383) of std_logic_vector(31 downto 0);
    type mstate_t is (M_IDLE, M_WAIT, M_DATA);
    function init_mem return mem_t is
        variable m : mem_t;
    begin
        for i in m'range loop
            m(i) := x"DA7A" & std_logic_vector(to_unsigned(4 * i, 16));
        end loop;
        return m;
    end init_mem;

    signal dq : std_logic_vector(31 downto 0);
    signal oe : std_logic := '0';
 
begin
    Sysdata <= dq after 1 ns when oe = '1' else (others => 'Z') after 1 ns;
    process (clk)
        variable mem : mem_t := init_mem;
        variable st : mstate_t := M_IDLE;
        variable cnt : integer := 0;
        variable word : integer := 0;
        variable rd : std_logic := '0';
    begin
        if rising_edge(clk) then
            case st is
                when M_IDLE =>
                    if Sysstrobe = '1' then
                        word := to_integer(unsigned(Sysaddress(15 downto 2)));
                        rd := Sysrw;
                        cnt := 4;
                        st := M_WAIT;
                    end if;
                when M_WAIT =>
                    cnt := cnt - 1;
                    if cnt = 0 then
                        if rd = '1' then
                            dq <= mem(word) after 1 ns;
                            oe <= '1' after 1 ns;
                            st := M_DATA;
                        else
                            mem(word) := Sysdata;
                            st := M_IDLE;
                        end if;
                    end if;
                when M_DATA =>
                    oe <= '0' after 1 ns;
                    st := M_IDLE;
            end case;
        end if;
    end process;

end behav;

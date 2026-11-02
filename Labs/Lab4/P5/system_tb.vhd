library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity system_tb is
end system_tb;

architecture sim of system_tb is
    type mem_t is array (0 to 16383) of std_logic_vector(31 downto 0);
    type tag_array_t is array (0 to 255) of natural;

    function init_mem return mem_t is
        variable m : mem_t;
    begin
        for i in m'range loop
            m(i) := x"DA7A" & std_logic_vector(to_unsigned(4 * i, 16));
        end loop;
        return m;
    end init_mem;

    function to_hex(v : std_logic_vector) return string is
        constant HEX : string(1 to 16) := "0123456789ABCDEF";
        constant N : natural := (v'length + 3) / 4;
        variable pad : std_logic_vector(4 * N - 1 downto 0) := (others => '0');
        variable nib : std_logic_vector(3 downto 0);
        variable s : string(1 to N);
    begin
        pad(v'length - 1 downto 0) := v;
        for i in 0 to N - 1 loop
            nib := pad(4 * N - 1 - 4 * i downto 4 * N - 4 - 4 * i);
            if is_x(nib) then
                s(i + 1) := 'X';
            else
                s(i + 1) := HEX(to_integer(unsigned(nib)) + 1);
            end if;
        end loop;
        return s;
    end to_hex;

    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal done : boolean := false;

    signal Pstrobe : std_logic := '0';
    signal Prw : std_logic := '0';
    signal Paddr : std_logic_vector(15 downto 0) := (others => 'Z');
    signal Pdata : std_logic_vector(31 downto 0) := (others => 'Z');
    signal Pready : std_logic;
    signal Sysstrobe : std_logic;
    signal Sysrw : std_logic;
    signal Sysaddress : std_logic_vector(15 downto 0);
    signal Sysdata : std_logic_vector(31 downto 0);
begin
    clk <= not clk after 50 ns when not done else '0';
    u_cache : entity work.cache
        port map (
            Pstrobe => Pstrobe,
            Prw => Prw,
            Paddr => Paddr,
            Pdata => Pdata,
            Pready => Pready,
            Sysstrobe => Sysstrobe,
            Sysrw => Sysrw,
            Sysaddress => Sysaddress,
            Sysdata => Sysdata,
            clk => clk,
            reset => reset
        );
    u_mem : entity work.main_memory
        port map (
            clk => clk,
            Sysstrobe => Sysstrobe,
            Sysrw => Sysrw,
            Sysaddress => Sysaddress,
            Sysdata => Sysdata
        );
    process
        variable g_mem : mem_t := init_mem;
        variable g_tag : tag_array_t := (others => 0);
        variable g_valid : std_logic_vector(0 to 255) := (others => '0');
        variable n : natural := 0;
        variable errors : natural := 0;
        variable hits : natural := 0;
        variable misses : natural := 0;
        procedure print(s : string) is variable l : line;
        begin
            write(l, s);
            writeline(output, l);
        end print;
        procedure cpu_access(rw : std_logic; addr : std_logic_vector(15 downto 0); wdata : std_logic_vector(31 downto 0)) is
            variable idx : natural := to_integer(unsigned(addr(9 downto 2)));
            variable tag : natural := to_integer(unsigned(addr(15 downto 10)));
            variable word : natural := to_integer(unsigned(addr(15 downto 2)));
            variable p_hit : boolean := g_valid(idx) = '1' and g_tag(idx) = tag;
            variable cycles : natural := 0;
            variable data : std_logic_vector(31 downto 0);
            variable expected : natural;
            variable ok : boolean;
            variable result : string(1 to 7);
        begin
            n := n + 1;
            Pstrobe <= '1' after 1 ns;
            Paddr <= addr after 1 ns;
            Prw <= rw after 1 ns;
            if rw = '0' then
                Pdata <= wdata after 1 ns;
            end if;
            loop
                wait until rising_edge(clk);
                cycles := cycles + 1;
                if cycles = 1 then
                    Pstrobe <= '0' after 1 ns;
                end if;
                exit when Pready = '1' or cycles = 50;
            end loop;
            if rw = '1' then
                data := Pdata;
            else
                data := wdata;
            end if;
            Paddr <= (others => 'Z') after 1 ns;
            Pdata <= (others => 'Z') after 1 ns;
            Prw <= '0' after 1 ns;

            if rw = '1' then
                if p_hit then
                    expected := 2;
                else
                    expected := 8;
                end if;
                ok := cycles = expected and data = g_mem(word);
                if cycles = 2 then
                    result := "HIT    ";
                    hits := hits + 1;
                else
                    result := "MISS   ";
                    misses := misses + 1;
                end if;
            else
                ok := cycles = 7;
                if p_hit then
                    result := "WR-HIT ";
                else
                    result := "WR-MISS";
                end if;
            end if;

            if ok then
                print("[" & integer'image(n) & "] 0x" & to_hex(addr) & "  " & result & "  " & integer'image(cycles) & " cycles  data " & to_hex(data));
            else
                errors := errors + 1;
                print("[" & integer'image(n) & "] 0x" & to_hex(addr) & "  " & result & "  " & integer'image(cycles) & " cycles  data " & to_hex(data) & "  ERROR, expected data " & to_hex(g_mem(word)));
            end if;
            g_valid(idx) := '1';
            g_tag(idx) := tag;
            if rw = '0' then
                g_mem(word) := wdata;
            end if;
            wait until rising_edge(clk);
        end cpu_access;
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        reset <= '0' after 1 ns;
        wait until rising_edge(clk);
        cpu_access('1', x"0012", x"00000000");
        cpu_access('1', x"0045", x"00000000");
        cpu_access('1', x"0076", x"00000000");
        cpu_access('1', x"0066", x"00000000");
        cpu_access('1', x"0076", x"00000000");
        cpu_access('1', x"0059", x"00000000");
        cpu_access('1', x"0045", x"00000000");
        cpu_access('1', x"0012", x"00000000");
        print(integer'image(misses) & " misses, " & integer'image(hits) & " hits");
        print("");
        cpu_access('0', x"0076", x"12345678");
        cpu_access('1', x"0076", x"00000000");
        cpu_access('1', x"0476", x"00000000");
        cpu_access('1', x"0076", x"00000000");
        cpu_access('0', x"0812", x"9ABCDEF0");
        cpu_access('1', x"0812", x"00000000");
        cpu_access('1', x"0012", x"00000000");
        print("");
        if errors = 0 then
            print("PASS: all " & integer'image(n) & " accesses correct");
        else
            print("FAIL: " & integer'image(errors) & " errors");
        end if;
        assert errors = 0 report "cache test failed" severity error;
        done <= true;
        wait;
    end process;
end sim;
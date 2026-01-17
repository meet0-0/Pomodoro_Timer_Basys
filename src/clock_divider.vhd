library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider is
    port (
        clk100 : in  std_logic;
        reset  : in  std_logic;
        clk1hz : out std_logic;
        clk1k  : out std_logic
    );
end entity;

architecture rtl of clock_divider is
    signal cnt1hz : unsigned(25 downto 0) := (others => '0');
    signal cnt1k  : unsigned(15 downto 0) := (others => '0'); 
    signal r1hz   : std_logic := '0';
    signal r1k    : std_logic := '0';
begin
    clk1hz <= r1hz;
    clk1k  <= r1k;

    process(clk100)
    begin
        if rising_edge(clk100) then
            if reset = '1' then
                cnt1hz <= (others => '0');
                cnt1k  <= (others => '0');
                r1hz   <= '0';
                r1k    <= '0';
            else
                if cnt1hz = 49_999_999 then
                    cnt1hz <= (others => '0');
                    r1hz   <= not r1hz;
                else
                    cnt1hz <= cnt1hz + 1;
                end if;

                if cnt1k = 49_999 then
                    cnt1k <= (others => '0');
                    r1k   <= not r1k;
                else
                    cnt1k <= cnt1k + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;

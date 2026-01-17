library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg is
    port (
        clk     : in  std_logic;
        minutes : in  unsigned(5 downto 0);
        seconds : in  unsigned(5 downto 0);
        an      : out std_logic_vector(3 downto 0);
        seg     : out std_logic_vector(6 downto 0);
        dp      : out std_logic
    );
end entity;

architecture rtl of seven_seg is
    signal sel   : unsigned(1 downto 0) := "00";
    signal digit : unsigned(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            sel <= sel + 1;
        end if;
    end process;

    an <= "1110" when sel = "00" else
          "1101" when sel = "01" else
          "1011" when sel = "10" else
          "0111";

    dp <= '0' when sel = "10" else '1';

    process(sel, minutes, seconds)
        variable val : unsigned(5 downto 0);
    begin
        case sel is
            when "00" =>
                val := seconds mod 10;
                digit <= resize(val, 4);
            when "01" =>
                val := seconds / 10;
                digit <= resize(val, 4);
            when "10" =>
                val := minutes mod 10;
                digit <= resize(val, 4);
            when others =>
                val := minutes / 10;
                digit <= resize(val, 4);
        end case;
    end process;

    with digit select
        seg <= "1000000" when "0000", --0
               "1111001" when "0001", --1
               "0100100" when "0010", --2
               "0110000" when "0011", --3
               "0011001" when "0100", --4
               "0010010" when "0101", --5
               "0000010" when "0110", --6
               "1111000" when "0111", --7
               "0000000" when "1000", --8
               "0010000" when "1001", --9
               "1111111" when others; --blank
end architecture;

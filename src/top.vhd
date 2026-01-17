library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        clk100 : in  std_logic;

        btnC   : in  std_logic; -- start
        btnD   : in  std_logic; -- stop
        btnU   : in  std_logic; -- reset
        btnL   : in  std_logic; -- manual WORK/BREAK toggle (when inactive)

        sw     : in  std_logic_vector(9 downto 0);
        led    : out std_logic_vector(9 downto 0);

        an     : out std_logic_vector(3 downto 0);
        seg    : out std_logic_vector(6 downto 0);
        dp     : out std_logic
    );
end entity;

architecture rtl of top is
    signal clk1hz, clk1k : std_logic;

    signal running : std_logic;

    signal mode_sel : std_logic := '1';

    signal minutes  : unsigned(5 downto 0) := (others => '0');
    signal seconds  : unsigned(5 downto 0) := (others => '0');
    signal done     : std_logic;

    signal work_min  : unsigned(5 downto 0);
    signal break_min : unsigned(5 downto 0);

    signal btnL_prev : std_logic := '0';
    signal btnL_p    : std_logic := '0';

    signal auto_sw_1hz : std_logic := '0';

    signal asw_ff0, asw_ff1 : std_logic := '0';
    signal asw_prev         : std_logic := '0';
    signal auto_sw_p_1k     : std_logic := '0';

    signal ms_ff0, ms_ff1 : std_logic := '1';
    signal mode_sel_1hz   : std_logic := '1';
begin
    led <= sw;

    work_min  <= unsigned(sw(5 downto 0));            -- SW(5:0)
    break_min <= resize(unsigned(sw(9 downto 6)), 6); -- SW(9:6)

    done <= '1' when (minutes = 0 and seconds = 0) else '0';

    clkdiv : entity work.clock_divider
        port map (
            clk100 => clk100,
            reset  => btnU,
            clk1hz => clk1hz,
            clk1k  => clk1k
        );

    fsm : entity work.pomodoro_fsm
        port map (
            clk      => clk1k,
            reset    => btnU,
            start    => btnC,
            stop     => btnD,
            done     => done,
            running  => running,
            workmode => open
        );

    process(clk1k)
    begin
        if rising_edge(clk1k) then
            if btnU = '1' then
                btnL_prev   <= '0';
                btnL_p      <= '0';
                mode_sel    <= '1';

                asw_ff0     <= '0';
                asw_ff1     <= '0';
                asw_prev    <= '0';
                auto_sw_p_1k<= '0';
            else
                btnL_p    <= btnL and (not btnL_prev);
                btnL_prev <= btnL;

                asw_ff0 <= auto_sw_1hz;
                asw_ff1 <= asw_ff0;

                auto_sw_p_1k <= asw_ff1 and (not asw_prev);
                asw_prev     <= asw_ff1;

                if (running = '0') and (btnL_p = '1') then
                    mode_sel <= not mode_sel;
                end if;
                if auto_sw_p_1k = '1' then
                    mode_sel <= not mode_sel;
                end if;
            end if;
        end if;
    end process;

    process(clk1hz)
    begin
        if rising_edge(clk1hz) then
            if btnU = '1' then
                ms_ff0 <= '1';
                ms_ff1 <= '1';
            else
                ms_ff0 <= mode_sel;
                ms_ff1 <= ms_ff0;
            end if;
        end if;
    end process;

    mode_sel_1hz <= ms_ff1;

    process(clk1hz)
    begin
        if rising_edge(clk1hz) then
            if btnU = '1' then
                if mode_sel_1hz = '1' then
                    minutes <= work_min;
                else
                    minutes <= break_min;
                end if;
                seconds <= (others => '0');
                auto_sw_1hz <= '0';

            elsif running = '0' then
                if mode_sel_1hz = '1' then
                    minutes <= work_min;
                else
                    minutes <= break_min;
                end if;
                seconds <= (others => '0');
                auto_sw_1hz <= '0';

            else
                if done = '1' then
                    auto_sw_1hz <= '1';

                    if mode_sel_1hz = '1' then
                        minutes <= break_min; -- work finished -> show break
                    else
                        minutes <= work_min;  -- break finished -> show work
                    end if;
                    seconds <= (others => '0');

                else
                    auto_sw_1hz <= '0';

                    if seconds = 0 then
                        if minutes /= 0 then
                            minutes <= minutes - 1;
                            seconds <= to_unsigned(59, 6);
                        end if;
                    else
                        seconds <= seconds - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    display : entity work.seven_seg
        port map (
            clk     => clk1k,
            minutes => minutes,
            seconds => seconds,
            an      => an,
            seg     => seg,
            dp      => dp
        );
end architecture;

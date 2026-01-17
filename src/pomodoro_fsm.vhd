library ieee;
use ieee.std_logic_1164.all;

entity pomodoro_fsm is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        start    : in  std_logic;
        stop     : in  std_logic;
        done     : in  std_logic;
        running  : out std_logic;
        workmode : out std_logic
    );
end entity;

architecture rtl of pomodoro_fsm is
    type state_t is (IDLE, WORK, BREAK, PAUSE);
    signal state, prev : state_t := IDLE;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
                prev  <= WORK;
            else
                case state is
                    when IDLE =>
                        if start = '1' then
                            state <= WORK;
                        end if;

                    when WORK =>
                        if done = '1' then
                            state <= BREAK;
                        elsif stop = '1' then
                            prev  <= WORK;
                            state <= PAUSE;
                        end if;

                    when BREAK =>
                        if done = '1' then
                            state <= WORK;
                        elsif stop = '1' then
                            prev  <= BREAK;
                            state <= PAUSE;
                        end if;

                    when PAUSE =>
                        if start = '1' then
                            state <= prev;
                        end if;
                end case;
            end if;
        end if;
    end process;

    running <= '1' when (state = WORK) or (state = BREAK) else '0';

    workmode <= '1' when (state = IDLE) or (state = WORK) else '0';
end architecture;

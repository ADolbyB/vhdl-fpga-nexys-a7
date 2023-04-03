-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file implements a locking system state machine that acts as a 2.5 second delay.
-- This delay allows the user to view the output for a period of time before it goes to the idle state.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity locking_system is
    port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        req_short_lock : in  std_logic;
        req_long_lock  : in  std_logic;
        lock           : out std_logic 
    );
end locking_system;

architecture behavioral of locking_system is
    type state is (IDLE, SHORT_LOCK, LONG_LOCK);
    signal current_state, next_state: state;

    signal counter: unsigned(27 downto 0);
    signal counter_short_done: std_logic;
    signal counter_long_done: std_logic;
begin

    FSM_NEXT_STATE: process(current_state, req_short_lock, req_long_lock, counter_short_done, counter_long_done)
    begin
        case current_state is
            when IDLE =>
                if req_short_lock = '1' then
                    next_state <= SHORT_LOCK;
                elsif req_long_lock = '1' then
                    next_state <= LONG_LOCK;
                else
                    next_state <= IDLE;
                end if;
            when SHORT_LOCK =>
                if req_long_lock = '1' then
                    next_state <= LONG_LOCK;
                elsif counter_short_done = '1' then
                    next_state <= IDLE;
                else
                    next_state <= SHORT_LOCK;
                end if;
            when LONG_LOCK =>
                if counter_long_done = '1' then
                    next_state <= IDLE;
                else
                    next_state <= LONG_LOCK;
                end if;
            when others =>
                next_state <= IDLE;
        end case;
    end process;

    FSM_CURRENT_STATE: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                current_state <= IDLE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    COUNTER_REG : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = IDLE then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    counter_short_done <= '1' when counter(15 downto 0) = x"ffff" else '0';
    counter_long_done <= '1' when counter = x"fffffff" else '0';

    lock <= '1' when (current_state /= IDLE) else '0';
end behavioral;
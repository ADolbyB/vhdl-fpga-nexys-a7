-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file implements the binary to BCD conversion for the 7 segment display.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_bcd is
    port (
        clk     : in  std_logic;
        din     : in  std_logic_vector(11 downto 0);
        dout    : out std_logic_vector(15 downto 0)
    );
end bin_bcd;

architecture behavioral of bin_bcd is
    type state is (LOAD, COMPUTE);
    signal current_state, next_state: state;

    signal counter      : unsigned(3 downto 0);
    signal counter_done : std_logic;

    signal data_check   : unsigned(27 downto 0);
    signal data         : unsigned(27 downto 0);
begin
    FSM_NEXT_STATE: process(current_state, counter_done)
    begin
        case current_state is
            when LOAD =>
                next_state <= COMPUTE;
            when COMPUTE =>
                if counter_done = '1' then
                    next_state <= LOAD;
                else
                    next_state <= COMPUTE;
                end if;
            when others =>
                next_state <= LOAD;
        end case;
    end process;

    FSM_CURRENT_STATE: process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    COUNTER_REG : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = LOAD then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    counter_done <= '1' when counter = x"B" else '0';

    -- Data
    data_check(11 downto 0)  <= data(11 downto 0);
    data_check(15 downto 12) <= data(15 downto 12)+3 when data(15 downto 12) > 4 else data(15 downto 12);
    data_check(19 downto 16) <= data(19 downto 16)+3 when data(19 downto 16) > 4 else data(19 downto 16);
    data_check(23 downto 20) <= data(23 downto 20)+3 when data(23 downto 20) > 4 else data(23 downto 20);
    data_check(27 downto 24) <= data(27 downto 24)+3 when data(27 downto 24) > 4 else data(27 downto 24);
    
    DATA_REG: process(clk)
    begin
        if rising_edge(clk) then
            case current_state is
                when COMPUTE =>
                    data <= shift_left(data_check, 1);
                when others =>
                    data(11 downto 0) <= unsigned(din);
                    data(27 downto 12) <= (others => '0');
            end case;
        end if;
    end process;


    OUTPUT_REG : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = LOAD then
                dout <= std_logic_vector(data(27 downto 12));
            end if;
        end if;
    end process;

end behavioral;
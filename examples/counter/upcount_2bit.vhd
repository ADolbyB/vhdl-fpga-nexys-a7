-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- 2 bit up-counter w/ synchronous reset.
-- Uses a D Flip Flop

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity upcount_2bit is
    PORT (
        Clear, Clock : IN std_logic;
        Q : OUT std_logic_vector(1 downto 0) -- 2 bit counter
    );
end upcount_2bit;

architecture behavioral of upcount_2bit is
    signal Count : std_logic_vector(1 downto 0);
begin
    upcount_2bit : process(Clock)
    begin
        if rising_edge(Clock) then
            if Clear = '1' then -- SYNCHRONOUS Reset
                Count <= "00";
            else
                Count <= Count + 1;
            end if;
        end if;
    end process;
    Q <= Count;
end behavioral;
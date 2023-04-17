-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- 4 bit up-counter w/ ASYNC reset.
-- Uses a D Flip Flop

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity upcount_4bit is
    PORT (
        Clock, ResetN, Enable : IN std_logic;
        Q : OUT std_logic_vector(3 downto 0) -- 4 bit counter
    );
end upcount_4bit;

architecture behavioral of upcount_4bit is
    signal Count : std_logic_vector(3 downto 0);
begin
    process(Clock, ResetN)
    begin
        if ResetN = '0' then -- ASYNC reset (Active Low)
            Count <= "0000"; -- Count <= (OTHERS => '0')
        elsif rising_edge(Clock) then
            if Enable = '1' then
                Count <= Count + 1;
            end if;
        end if;
    end process;
    Q <= Count;
end behavioral;
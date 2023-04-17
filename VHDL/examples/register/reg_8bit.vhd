-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an example of an 8-bit register
-- A Register is just a collection of D Flip Flops

library IEEE;
USE IEEE.std_logic_1164.all;

Entity reg_8bit is
    PORT (
        Clock, ResetN : IN std_logic;
        D : IN std_logic_vector(7 downto 0);
        Q : OUT std_logic_vector(7 downto 0)
    );
end entity reg_8bit;

architecture behavioral of reg_8bit is
    
begin
    process (ResetN, Clock) -- Async Reset / Clear
    begin
        if ResetN = '0' then
            Q <= "00000000"; -- 8 bits out
        elsif rising_edge(Clock) then
            Q <= D;
        end if;
    end process;
end architecture behavioral;
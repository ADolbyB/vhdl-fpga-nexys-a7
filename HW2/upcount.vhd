-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a behavioral model for a 4 bit unsigned counter.

library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

entity upcount is
    port (
        Clock  : in std_logic;
        ResetN : in std_logic;
        Enable : in std_logic;
        Q : out std_logic_vector(3 downto 0)        
    );
end upcount;

architecture behavior of upcount is
    Signal Count : std_logic_vector(3 downto 0);
begin
    process (Clock, ResetN)
    begin
        if ResetN = '0' THEN
            Count <= "0000";
        elsif (Clock'event AND Clock = '1') then
            if Enable = '1' then
                Count <= Count + 1;
            else
                Count <= Count;
            end if;
        end if;
    end process;
    Q <= Count;

end architecture;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an example of an N-bit generic register w/ ENABLE
-- Enable can ONLY be syncronous

library IEEE;
USE IEEE.std_logic_1164.all;

Entity reg_Nbit_en is
    generic (
        N : integer := 16 -- Generic Declaration for N = 16 bits
    );
    PORT (
        Clock, Enable : IN std_logic; -- Enable instead of Reset
        D : IN std_logic_vector(N-1 downto 0);
        Q : OUT std_logic_vector(N-1 downto 0)
    );
end entity reg_Nbit_en;

architecture behavioral of reg_Nbit_en is
begin
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end architecture behavioral;
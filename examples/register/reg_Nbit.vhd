-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an example of an N-bit generic register
-- A Register is a collection of D Flip Flops

library IEEE;
USE IEEE.std_logic_1164.all;

Entity reg_Nbit is
    generic (
        N : integer := 16 -- Generic Declaration for N = 16 bits
    );
    PORT (
        Clock, ResetN : IN std_logic;
        D : IN std_logic_vector(N-1 downto 0);
        Q : OUT std_logic_vector(N-1 downto 0)
    );
end entity reg_Nbit;

architecture behavioral of reg_Nbit is
    
begin
    process (ResetN, Clock) -- Async Reset / Clear
    begin
        if ResetN = '0' then
            Q <= (OTHERS => 0); -- Set all N bits to 0
        elsif rising_edge(Clock) then
            Q <= D;
        end if;
    end process;
end architecture behavioral;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Program for a D Latch (Non-Flip Flop)

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity dlatch is
    PORT (
        D, Clock : IN std_logic;
        Q : OUT std_logic
    );
end entity dlatch;

Architecture behavioral of dlatch is
BEGIN
    process (D, Clock)
    BEGIN
        if Clock = '1' then
            Q <= D;
        end if;
    end process;
end behavioral;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Allternate Program for D Flip Flop.

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY dflipflop_alt IS
    PORT (
        D, clk, clr : IN std_logic;
        Q : OUT std_logic
    );
END ENTITY dflipflop_alt;

ARCHITECTURE behavioral OF dflipflop_alt IS
BEGIN
    PROCESS -- No Sensitivity List Here
    BEGIN
        WAIT UNTIL rising_edge(clk);
        Q <= D;
    END PROCESS;
END behavioral;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Program for D Flip Flop w/ ASYNCHRONOUS clear

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY dflipflop_aclr IS
    PORT (
        d, clk, clr : IN std_logic;
        q : OUT std_logic
    );
END ENTITY dflipflop_aclr;

ARCHITECTURE behavioral OF dflipflop_aclr IS
BEGIN
    PROCESS (clk, clr) -- Clear / Reset is sensitive.
    BEGIN
        IF clr = '0' THEN -- asynchronous process triggered
            q <= '0';     -- 'q' stays cleared as long as 'clr' == 0
        ELSIF rising_edge(clk) THEN -- Only checks clock if 'clr' != 0
            q <= d;
        END IF;
    END PROCESS;
END ARCHITECTURE behavioral;
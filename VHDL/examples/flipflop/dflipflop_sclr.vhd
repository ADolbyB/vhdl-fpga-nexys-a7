-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Program for D Flip Flop w/ SYNCRONOUS clear

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY dflipflop_sclr IS
    PORT (
        d, clk, clr : IN std_logic;
        q : OUT std_logic
    );
END ENTITY dflipflop_sclr;

ARCHITECTURE behavioral OF dflipflop_sclr IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge (clk) THEN
            IF clr = '0' THEN -- clear is only checked after clock change
               q <= '0';
            ELSE
                q <= d;
            END IF;
        END IF;
    END PROCESS;
END behavioral;
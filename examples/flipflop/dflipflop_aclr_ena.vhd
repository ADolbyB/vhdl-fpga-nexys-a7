-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Program for D Flip Flop w/ ASYNCRONOUS clear & ENABLE

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY dflipflop_aclr_ena IS
    PORT (
        d, clk, clr, ena : IN std_logic;
        q : OUT std_logic
    );
END ENTITY dflipflop_aclr_ena;

ARCHITECTURE rtl OF dflipflop_aclr_ena IS
BEGIN
    PROCESS (clk, clr)
    BEGIN
        IF clr = '0' THEN -- ASync clear goes 1st
            q <= '0';
        ELSIF rising_edge (clk) THEN -- Only check clock if 'clr' is not set
            IF ena = '1' THEN -- If 'ena' != 1, then 'q' retains prev value.
                q <= d;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;
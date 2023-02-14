-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Program for standard D Flip Flop

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY dflipflop IS
    PORT (
        clk, d : IN std_logic;
        q : OUT std_logic
    );
END ENTITY dflipflop;

ARCHITECTURE rtl of dflipflop IS
BEGIN
    PROCESS (clk)                           -- Process is triggered by the clock
    BEGIN
        IF rising_edge(clk) THEN            -- function defined in std_logic_1164
     -- IF falling_edge(clk) THEN           -- also valid for falling edge clock
     -- IF (clk'event AND clk = '1') THEN   -- This is "Conventional" for D Flip Flop
            q <= d;                         -- 'X' or 'Z' to 1 transition not allowed.
        END IF;                             -- signal value MUST be 0 to 1
    END PROCESS;
END ARCHITECTURE rtl;
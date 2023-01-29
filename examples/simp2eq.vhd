-- Joel Brigida
-- CDA 4240C: Digital Design Lab

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY simp2eq IS
    PORT (
        a, b : IN std_logic;
        y : OUT std_logic
    );
END ENTITY simp2eq;

ARCHITECTURE logic2eq OF simp1eq IS
   SIGNAL c : std_logic;
BEGIN
    
    Process1: PROCESS (a, b)
    BEGIN
        c <= a AND b;
    END PROCESS process1;
    
    Process2: PROCESS (c)
    BEGIN
        y <= c;
    END PROCESS process2; -- c and y get executed and updated in parallel
                          -- at the end   of the process WITHIN one simulation cycle.
END ARCHITECTURE logic2eq;
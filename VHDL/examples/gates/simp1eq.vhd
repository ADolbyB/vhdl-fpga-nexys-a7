-- Joel Brigida
-- CDA 4240C: Digital Design Lab

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY simp1eq IS
    PORT (
        a, b : IN std_logic;
        y : OUT std_logic
    );
END ENTITY simp1eq;

ARCHITECTURE logic1eq OF simp1eq IS
    SIGNAL c : std_logic;
BEGIN

    c <= a AND b; -- 2 Delta Cycles inside the same Simulation Cycle
    y <= c;

END ARCHITECTURE logic1eq;
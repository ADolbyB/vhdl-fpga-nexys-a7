-- Joel Brigida
-- CDA 4240C: Digital Design Lab

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY simp4eq IS
    PORT (
        a, b : IN std_logic;
        y : OUT std_logic
    );
END ENTITY simp4eq;

ARCHITECTURE logic4eq OF simp4eq IS
BEGIN
    PROCESS (a, b) -- process sensitive to (a, b)
        VARIABLE c : std_logic; -- Only visible inside the process
    BEGIN
        c := a AND b; -- Updated Immediately since 'c' is a variable
        y <= c;       -- 'y' gets the new value of 'c' immediately within 1 simulation cycle
    END PROCESS;

END ARCHITECTURE logic4eq;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY simp3uneq IS
    PORT (
        a, b : IN std_logic;
        y : OUT std_logic
    );
END ENTITY simp3uneq;

ARCHITECTURE logic3uneq OF simp3uneq IS
   SIGNAL c : std_logic;
BEGIN
    
    PROCESS (a, b)
    BEGIN
        c <= a AND b; -- 'c' isnt actually updated until after the PROCESS ends
        y <= c;       -- so 'y' gets the old value of 'c' until the next simulation cycle
    END PROCESS;      -- VARIABLES fix this problem (updated immediately)
                      -- (a, b) needs to change for process to run 2nd time for 'y' to get new value of 'c'
END ARCHITECTURE logic3uneq; 
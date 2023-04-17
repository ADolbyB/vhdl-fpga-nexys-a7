-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Alternative Implementation For Full Adder

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY fulladd_1 is
    PORT(
        X : IN STD_LOGIC;
        Y : IN STD_LOGIC;
        CIN : in STD_LOGIC;
        SUM : OUT STD_LOGIC;
        COUT : OUT STD_LOGIC
    );
END ENTITY fulladd_1;

architecture dataflow OF fulladd_1 is
begin
    -- Dataflow implementation describes gate level implementation
    SUM <= X XOR Y XOR CIN;
    cout <= (X AND Y) OR (CIN AND X) OR (CIN AND Y));

end dataflow;
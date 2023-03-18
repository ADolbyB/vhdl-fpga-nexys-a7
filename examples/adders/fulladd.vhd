-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- VHDL program for a Full Adder

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY fulladd is
    PORT(
        X : IN STD_LOGIC;
        Y : IN STD_LOGIC;
        CIN : in STD_LOGIC;
        SUM : OUT STD_LOGIC;
        COUT : OUT STD_LOGIC
    );
END ENTITY fulladd;

architecture dataflow OF fulladd is
begin
    -- Dataflow implementation describes gate level implementation
    SUM <= X XOR Y XOR CIN;
    cout <= (X AND Y) OR (CIN AND (X XOR Y));

end dataflow;
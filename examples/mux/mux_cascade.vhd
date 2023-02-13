-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a DATAFLOW example of a cascade of 2 2to1 muxes to produce a 4to1 mux
-- Demostrates use of WHEN/ELSE priority logic

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package


ENTITY mux_cascade IS
    PORT (
        w1, w2, w3 : IN STD_LOGIC;
        s1, s2 : IN STD_LOGIC; -- Signal Select
        f : OUT STD_LOGIC
    );
END ENTITY mux_cascade;
    
architecture dataflow OF mux_cascade is

begin
    
    f <= w1 WHEN s1 = '1' else -- Priority Logic: This statement has highest priority
         w2 WHEN s2 = '1' else -- If s1 == 1, then we dont care what s2 is.
         w3;                   -- Only true when both selects are '0'

end dataflow;
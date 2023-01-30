-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- DATAFLOW Example of an AND gate in VHDL
-- This dataflow architecture focuses on the 
-- logic gate level implementation of the circuit

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity and_gate1 is
    port(
        A, B : in BIT; -- A maps to X and P, B maps to Y and Q
        C : out BIT
    );
end entity and_gate1;

architecture dataflow of and_gate1 is
begin -- describe the DATAFLOW of the and gate

    C <= A AND B;

end dataflow;
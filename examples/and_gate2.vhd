-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- BEHAVIORAL Example of an AND gate in VHDL
-- Here there is no need to focus on gate-level implementation of the design
-- instead it just focuses on how the circuit behaves at a higher level.
-- It is the compiler and synthesis tool that produces the gate level implementation

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity and_gate2 is
    port(
        A, B : in BIT; -- A maps to X and P, B maps to Y and Q
        C : out BIT
    );
end entity and_gate2;

architecture behavior of and_gate2 is
begin -- Describe the BEHAVIOR of the architecture
    process(A, B)
    begin
        if a = '1' and b = '1' then
            c <= '1';
        else
            c <= '0';
        end if;
    end process;
end behavior;
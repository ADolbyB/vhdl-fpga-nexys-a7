-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- DATAFLOW (Low Level) Example of a half adder in VHDL

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity halfadd2 is
    port(
        A, B : in BIT; -- A maps to X and P, B maps to Y and Q
        SUM, CARRY : out BIT
    );
end entity halfadd2;

architecture dataflow of halfadd2 is
begin

    SUM <= A XOR B;
    CARRY <= A AND B;

end dataflow;
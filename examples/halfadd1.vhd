-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- STRUCTURAL Example of a half adder in VHDL

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity halfadd1 is
    port(
        A, B : in BIT; -- A maps to X and P, B maps to Y and Q
        SUM, CARRY : out BIT
    );
end entity halfadd1;

architecture structure of halfadd1 is
    component XOR1
        port(
            P, Q : in BIT;
            R : out BIT -- R == SUM
        );
    end component;
    component AND1
        port(
            X, Y : in BIT;
            Z : out BIT -- Z == CARRY
        );
    end component;

begin
    X1 : XOR1 port map(
        A, B, SUM
    );
    A1 : AND1 port map(
        A, B, CARRY
    );
end structure;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a BEHAVIORAL example of a 3 input XOR gate

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity xor3 is
    port (
        A : in std_logic;
        B : in std_logic;
        C : in std_logic;
        Result : out std_logic
    );
end entity xor3;

architecture behavioral OF xor3 IS

begin
    
    xor3_behave : PROCESS (A, B, C) -- Inputs

begin -- Behavior of circuit / process.
    IF ((A XOR B XOR C) = '1') THEN
        Result <= '1';
    ELSE
        Result <= '0';
    END IF;

    END PROCESS xor3_behave;
END behavioral;
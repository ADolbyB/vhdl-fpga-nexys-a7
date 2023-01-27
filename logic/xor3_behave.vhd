library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

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
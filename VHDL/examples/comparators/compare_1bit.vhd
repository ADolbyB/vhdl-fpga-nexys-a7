-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- BEHAVIORAL example of 1 bit comparator
-- Compares a 1 bit channel A to a 1 bit Channel B
-- Produces a 1 bit output on channel AeqB

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package
use ieee.std_logic_signed.all; -- Use SIGNED integer library

ENTITY compare_1bit IS
    PORT(
        A : IN STD_LOGIC;       -- 4 bit channel A in (MSB = 3)
        B : IN STD_LOGIC;       -- 4 bit channel B in (MSB = 3)
        AeqB : OUT STD_LOGIC;   -- If A == B (1 bit OUT)
    );
END compare_1bit;

architecture behavior OF compare_1bit IS

begin

    PROCESS(A, B)
        begin
            AeqB <= '0';
            IF A = B THEN
                AeqB <= '1';
            END IF;
    END PROCESS;

end behavior;
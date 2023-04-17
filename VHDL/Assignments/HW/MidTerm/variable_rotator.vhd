-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 16 bit variable rotator.
-- This is a STRUCTURAL example

library IEEE;
USE IEEE.std_logic_1164.all;

entity variable_rotator is
    GENERIC(L : integer := 1); -- L = number of bits to rotate Left
    PORT(
        A : IN std_logic_vector(15 downto 0); -- 16bit Rotator
        B : IN std_logic_vector(3 downto 0);
        C : OUT std_logic_vector(15 downto 0)
    );
end variable_rotator;

architecture structural OF variable_rotator is
    -- Create New Array
    TYPE array16 IS ARRAY (0 to 4) of std_logic_vector(15 downto 0);
    SIGNAL AL : array16;
    SIGNAL AR : array16;
begin
    AL(0) <= A;
    G : FOR i IN 0 TO 3 GENERATE
        AR(i) <= AL(i)((15-2 ** i) downto 0) & (AL(i)(15-2 ** i+1));
        AL(i + 1) <= AL(i) when B(i) = '0' else AR(i);
            END GENERATE;
                C <= AL(4);
end structural;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 16 bit fixed rotator which rotates left.
-- This is a STRUCTURAL example

library IEEE;
USE IEEE.std_logic_1164.all;

entity var_16bit_left is
    GENERIC(L : integer := 1); -- L = number of bits to rotate Left
    PORT(
        A : IN std_logic_vector(15 downto 0);
        B : IN std_logic_vector(3 downto 0);
        C : OUT std_logic_vector(15 downto 0)
    );
end var_16bit_left;

architecture structural OF var_16bit_left is
    -- Create New Array
    TYPE array16 IS ARRAY (0 to 4) of std_logic_vector(15 downto 0);
    SIGNAL AL : array16;
    SIGNAL AR : array16;
begin
    AL(0) <= A;
    G : FOR i IN 0 TO 3 GENERATE
        ROT_I : ENTITY work.fixed_16bit_left(dataflow)
            GENERIC MAP (L => 2 ** i)
            PORT MAP (
                A => AL(i),
                Y => AR(i)
            );
        MUX_I : ENTITY work.mux2to1_16bit(dataflow)
            PORT MAP (
                W0 => AL(i),
                W1 => AR(i),
                SEL => B(i),
                F => AL(i + 1)
            );
    end GENERATE;
    C <= AL(4);
end structural;
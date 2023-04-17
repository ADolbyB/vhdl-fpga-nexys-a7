-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 16 bit fixed rotator which rotates left.
-- This is a DATAFLOW example

library IEEE;
USE IEEE.std_logic_1164.all;

entity mux2to1_16bit is
    PORT(
        W0 : IN std_logic_vector(15 downto 0);
        W1 : IN std_logic_vector(15 downto 0);
        SEL : IN std_logic;
        F : OUT std_logic_vector(15 downto 0)
    );
end mux2to1_16bit;

architecture dataflow OF mux2to1_16bit is
begin
    F <= W0 WHEN SEL = '0' ELSE W1;
end dataflow;
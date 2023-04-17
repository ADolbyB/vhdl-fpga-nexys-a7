-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 16 bit fixed rotator which rotates left.
-- This is a DATAFLOW example

library IEEE;
USE IEEE.std_logic_1164.all;

entity fixed_16bit_left is
    GENERIC(L : integer := 1); -- L = number of bits to rotate Left
    PORT(
        A : IN std_logic_vector(15 downto 0);
        Y : OUT std_logic_vector(15 downto 0)
    );
end fixed_16bit_left;

architecture dataflow OF fixed_16bit_left is
begin
    Y <= A(15-L downto 0) & A(15 downto 15-L + 1); -- Bit Order: 14, 13, ... , 0, 15
end dataflow;
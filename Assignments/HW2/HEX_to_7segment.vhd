-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a dataflow model for a Hexadecimal to 7 segment display.
-- HEX input is used to display digits 0 - 9 and A - F
-- This is for a Common Cathode Display: Logic '1' required to illuminate segments

library IEEE;
use ieee.std_logic_1164.all;

Entity HEX_to_7segment is
    Port(
        HEX : in std_logic_vector(3 downto 0); -- 4 bit HEX signal
        DISP : out std_logic_vector(6 downto 0) -- 7 Segment Display
    );
End Entity HEX_to_7segment;

Architecture dataflow of HEX_to_7segment is

begin
    with HEX select
          -- abcdefg display segments
    DISP <= "1111110" when "0000", -- Displays '0'
            "0110000" when "0001", -- Displays '1'
            "1101101" when "0010", -- Displays '2'
            "1111001" when "0011", -- Displays '3'
            "0110011" when "0100", -- Displays '4'
            "1011011" when "0101", -- Displays '5'
            "0011111" when "0110", -- Displays '6'
            "1110000" when "0111", -- Displays '7'
            "1111111" when "1000", -- Displays '8'
            "1100011" when "1001", -- Displays '9'
            "1110111" when "1010", -- Displays 'A'
            "0011111" when "1011", -- Displays 'b'
            "1001110" when "1100", -- Displays 'C'
            "0111101" when "1101", -- Displays 'd'
            "1001111" when "1110", -- Displays 'E'
            "1000111" when "1111", -- Displays 'F'
            "0000000" when OTHERS; -- Turn off Display

end dataflow;
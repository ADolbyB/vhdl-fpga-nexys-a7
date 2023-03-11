-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a dataflow model for a Binary Coded Decimal to 7 segment display.
-- BCD Input is used to display numbers 0 - 9 (A - F are excluded)
-- This is for a Common Cathode Display: Logic '1' required to illuminate segments

library IEEE;
use ieee.std_logic_1164.all;

Entity BCD_to_7segment is
    Port(
        BCD : in std_logic_vector(3 downto 0); -- 4 bit BCD signal
        DISP : out std_logic_vector(6 downto 0) -- 7 Segment Display
    );
End Entity BCD_to_7segment;

Architecture dataflow of BCD_to_7segment is

begin
    with BCD select
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
            "-------" when OTHERS; -- Don't Care about other cases
         -- "0000000" when OTHERS; -- Turn Off Display

end dataflow;
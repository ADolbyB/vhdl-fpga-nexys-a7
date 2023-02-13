library IEEE;
use ieee.std_logic_1164.all;

Entity BCD_to_7segment is
    Port(
        BCD : in std_logic_vector(3 downto 0); -- 4 bit BCD signal
        DISP : out std_logic_vector(6 downto 0) -- 7 Segment Display
    );
End Entity BCD_to_7Segment;

Architecture dataflow of BCD_to_7segment is

begin
    with BCD select
    DISP <= "1111110" when "0000", -- Displays '0'
            "0110000" when "0001", -- Displays '1'
            "1101101" when "0010", -- Displays '2'
            "1111001" when "0011", -- Displays '3'
            "0110011" when "0100", -- Displays '4'
            "1011011" when "0101", -- Displays '5'
            "1111110" when "0110", -- Displays '6'
            "1111110" when "0111", -- Displays '7'
            "1111110" when "1000", -- Displays '8'
            "1111110" when "1001", -- Displays '9'
            "1111110" when "1010", -- Displays 'A'
            "1111110" when "1011", -- Displays 'b'
            "1111110" when "1100", -- Displays 'C'
            "1111110" when "1101", -- Displays 'd'
            "1111110" when "1110", -- Displays 'E'
            "1111110" when "1111", -- Displays 'F'
            "0000000" when OTHERS;

end dataflow;
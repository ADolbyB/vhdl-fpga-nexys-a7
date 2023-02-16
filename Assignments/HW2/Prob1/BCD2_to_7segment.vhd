-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is another exampl of a BCD to 7 Segment display
-- This example uses a CASE statement

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY BCD2_to_7segment IS
    PORT ( 
        BCD : IN std_logic_vector(3 downto 0); -- 4 bit Binary input
        SEGMENTS : OUT std_logic_vector(6 downto 0) -- 7 bit output to display
        );  
END BCD2_to_7segment;

ARCHITECTURE Behavior OF BCD2_to_7segment IS
BEGIN
    PROCESS ( BCD )
    BEGIN
        CASE BCD IS                  -- abcdefg
            WHEN "0000" => SEGMENTS <= "1111110"; -- Displays '0'
            WHEN "0001" => SEGMENTS <= "0110000"; -- Displays '1'
            WHEN "0010" => SEGMENTS <= "1101101"; -- Displays '2'
            WHEN "0011" => SEGMENTS <= "1111001"; -- Displays '3'
            WHEN "0100" => SEGMENTS <= "0110011"; -- Displays '4'
            WHEN "0101" => SEGMENTS <= "1011011"; -- Displays '5'
            WHEN "0110" => SEGMENTS <= "1011111"; -- Displays '6'
            WHEN "0111" => SEGMENTS <= "1110000"; -- Displays '7'
            WHEN "1000" => SEGMENTS <= "1111111"; -- Displays '8'
            WHEN "1001" => SEGMENTS <= "1110011"; -- Displays '9'
            WHEN OTHERS => SEGMENTS <= "-------"; -- "Don't Care" about other cases.
         -- WHEN OTHERS => SEGMENTS <= "0000000"; -- Turn off display
        END CASE;
    END PROCESS;
END Behavior;
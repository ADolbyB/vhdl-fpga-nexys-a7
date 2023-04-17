-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This Is a ROM That implements the Function Y = 7x + 22 via a Look Up Table

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY ROM_7x22 is
    PORT(
        ADDR : IN STD_LOGIC_VECTOR(3 downto 0);
        DOUT : OUT STD_LOGIC_VECTOR(6 downto 0)
    );
END entity;

architecture dataflow of ROM_7x22 is

    signal TEMP : integer RANGE 0 to 15;
    type vector_array IS ARRAY (0 to 15) OF STD_LOGIC_VECTOR(6 downto 0);
    constant MEMORY : vector_array :=
        (
            std_logic_vector(to_unsigned(22, 7)),  -- x = 0
            std_logic_vector(to_unsigned(29, 7)),  -- x = 1
            std_logic_vector(to_unsigned(36, 7)),  -- x = 2
            std_logic_vector(to_unsigned(43, 7)),  -- x = 3
            std_logic_vector(to_unsigned(50, 7)),  -- x = 4
            std_logic_vector(to_unsigned(57, 7)),  -- x = 5
            std_logic_vector(to_unsigned(64, 7)),  -- x = 6
            std_logic_vector(to_unsigned(71, 7)),  -- x = 7
            std_logic_vector(to_unsigned(78, 7)),  -- x = 8
            std_logic_vector(to_unsigned(85, 7)),  -- x = 9
            std_logic_vector(to_unsigned(92, 7)),  -- x = 10
            std_logic_vector(to_unsigned(99, 7)),  -- x = 11
            std_logic_vector(to_unsigned(106, 7)), -- x = 12
            std_logic_vector(to_unsigned(113, 7)), -- x = 13
            std_logic_vector(to_unsigned(120, 7)), -- x = 14
            std_logic_vector(to_unsigned(127, 7))  -- x = 15
        );

begin

    TEMP <= to_integer(unsigned(ADDR));
    DOUT <= MEMORY(TEMP);

END dataflow;
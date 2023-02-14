-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an example of an 8x16 ROM.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom_8x16 is
    port (
        ADDR : in std_logic_vector(2 downto 0); -- 3 bit address
        DOUT : out std_logic_vector(15 downto 0) -- 16 bit Data Out
    );
end entity rom_8x16;

architecture dataflow of rom_8x16 is
    signal temp : INTEGER RANGE 0 to 7;
    type vector_array IS array (0 to 7) of std_logic_vector(15 downto 0);
    CONSTANT memory : vector_array := (
        X"800A",
        X"D459",
        X"A870",
        X"7853",
        X"650D",
        X"642F",
        X"F742",
        X"F548"
    );
begin
    temp <= to_integer(unsigned(ADDR));
    DOUT <= memory(temp);
end architecture dataflow;
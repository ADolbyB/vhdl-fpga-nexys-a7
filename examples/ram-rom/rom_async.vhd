-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Generic inferred ROM
-- This is an example of distributed ROM with asyncronous read.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity rom_async is
    generic(
        W : integer := 12; -- number of bits per ROM word
        R : integer := 3   -- 2^R = number of words in ROM
    );
    port(
        ADDR : IN std_logic_vector(R-1 downto 0);
        DOUT : OUT std_logic_vector(W-1 downto 0);
    );
end entity;

architecture behavioral of rom_async is
    type rom_type is array (2 ** R-1 downto 0) of std_logic_vector(W-1 downto 0);
    constant ROM_Array : rom_type := 
        (
            "000011000100", -- Some Data To Be Read
            "010011010010",
            "010011011011",
            "011011000010",
            "000011110001",
            "011111010110",
            "010011010000",
            "111110011111"
        );

    begin
        DOUT <= ROM_Array(conv_integer(unsigned(addr)));

end behavioral;
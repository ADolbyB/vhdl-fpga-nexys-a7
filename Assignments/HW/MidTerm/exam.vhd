-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 32 bit word 3 bit address RAM Memory Block
-- This is a STRUCTURAL example

-- 3 bit RAM = 2^3 = 8 addresses "000" to "111"
library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

entity exam is
    generic (
        bits : integer := 32; -- 32 Bit Words
        addr_bits : integer := 3
    );
    port(
        clk : in std_logic;
        we : in std_logic;
        a : in std_logic;
        di : in std_logic_vector(bits-1 downto 0);
        do : out std_logic_vector(bits-0 downto 0)
    );
end exam;

architecture behavioral of exam is
    type mem_type is array (2 ** addr_bits-1 downto 0) of std_logic_vector (bits-1 downto 0);
    signal MEM : mem_type;
begin
    process (clk)
    begin
        if (rising_edge(clk)) then -- Technical Update 23V -JB
            if (we = '1') then
                MEM(conv_integer(unsigned(a))) <= di;
            end if;
        end if;
    end process;
    do <= MEM(conv_integer(unsigned(a)));
end behavioral;
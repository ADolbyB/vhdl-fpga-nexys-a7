-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Generic inferred RAM
-- This is an example of distributed single port RAM with asyncronous read.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity RAM_async is
    generic(
        bits : integer := 32;       -- Number Of Bits Per RAM Word
        addr_bits : integer := 3    -- 2^addr_bits = Number of Words in RAM
    );
    port(
        CLK : in std_logic;
        WE : in std_logic;
        A : in std_logic_vector(addr_bits-1 downto 0);
        DIN : in std_logic_vector(bits-1 downto 0);
        DOUT : out std_logic_vector(bits-1 downto 0)
    );
end entity;

architecture behavioral of ram_async is
    
    type RAM_Type is array(2 ** addr_bits-1 downto 0) of std_logic_vector(bits-1 downto 0);
    signal RAM : RAM_Type;

begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if(WE = '1') then
                RAM(conv_integer(unsigned(A))) <= DIN;
            end if;
        end if;
    end process;
    do <= RAM(conv_integer(unsigned(A)));
    
end behavioral;
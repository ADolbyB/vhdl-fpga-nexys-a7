-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Block RAM with synchronous read.
-- This is an example of Read-First Mode RAM

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity RAM_sync is
    generic(
        W : integer := 32;  -- Number Of Bits Per RAM Word
        R : integer := 9    -- 2^R = Number of Words in RAM
    );
    port(
        CLK : in std_logic;
        WE : in std_logic;
        EN : in std_logic;
        ADDR : in std_logic_vector(R-1 downto 0);
        DIN : in std_logic_vector(W-1 downto 0);
        DOUT : out std_logic_vector(W-1 downto 0)
    );
end entity;

architecture behavioral of RAM_sync is

    type ram_type is array (2 ** R-1 downto 0) of std_logic_vector(W-1 downto 0);
    signal RAM : ram_type;

begin
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if (EN = '1') then -- READ 1st
                DOUT <= RAM(conv_integer(unsigned(ADDR)));
                if (WE = '1') then
                    RAM(conv_integer(unsigned(ADDR))) <= DIN;
                end if;
            end if;
        end if;
    end process;

end behavioral;
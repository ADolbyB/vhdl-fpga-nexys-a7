-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Generic inferred RAM
-- This is an example of distributed dual port RAM with asyncronous read.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity ram_async2 is
    generic(
        W : integer := 32;  -- Number Of Bits Per RAM Word
        R : integer := 6    -- 2^R = Number of Words in RAM
    );
    port(
        CLK : in std_logic;
        WE : in std_logic;
        A : in std_logic_vector(R-1 downto 0);
        DPR_A : in std_logic_vector(R-1 downto 0);
        DIN : in std_logic_vector(W-1 downto 0);
        SP_OUT : out std_logic_vector(W-1 downto 0);
        DP_OUT : out std_logic_vector(W-1 downto 0)
    );
end entity;

architecture syn of ram_async2 is
    type ram_type is array(2 ** R-1 downto 0) of std_logic_vector(W-1 downto 0);
    signal RAM : ram_type;

begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if (WE = '1') then
                RAM(conv_integer(unsigned(A))) <= DIN;
            end if;
        end if;
    end process;
    
    SP_OUT <= RAM(conv_integer(unsigned(A)));
    DP_OUT <= RAM(conv_integer(unsigned(DPR_A)));

end syn;
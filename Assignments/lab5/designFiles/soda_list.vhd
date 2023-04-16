-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Soda List Entity For The Vending Machine

-- SODA LIST
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soda_list is
    PORT(
        soda_sel      : in std_logic_vector(3 downto 0);
        soda_reserved : out std_logic;
        soda_price    : out std_logic_vector(11 downto 0)
    );
end soda_list;

architecture dataflow of soda_list is

begin

    WITH soda_sel SELECT soda_price
        <= X"037" WHEN "0000", -- Soda 0 = $0.55
           X"055" WHEN "0001", -- Soda 1 = $0.85
           X"05F" WHEN "0010", -- Soda 1 = $0.95
           X"07D" WHEN "0011", -- Soda 1 = $1.25
           X"087" WHEN "0100", -- Soda 1 = $1.35
           X"096" WHEN "0101", -- Soda 1 = $1.50
           X"0E1" WHEN "0110", -- Soda 1 = $2.25
           X"0FA" WHEN "0111", -- Soda 1 = $2.50
           X"12C" WHEN "1000", -- Soda 1 = $3.00
           X"000" WHEN OTHERS; -- Soda Reserved

    soda_reserved <= '1' WHEN unsigned(soda_sel) > 8 ELSE '0'; -- Set Soda Reserved Flag for Invalid Sodas.

end dataflow;
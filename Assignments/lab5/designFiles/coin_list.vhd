-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Coin List Entity For The Vending Machine

library ieee;
use ieee.std_logic_1164.all;

entity coin_list is
    PORT(
        coin_sel : in std_logic_vector(1 downto 0);
        coin_amt : out std_logic_vector(11 downto 0)
    );
end coin_list;

architecture data_flow of coin_list is

begin
    
    WITH coin_sel SELECT coin_amt
        <= "000000000001" WHEN "00", -- Penny
           "000000000101" WHEN "01", -- Nickel
           "000000001010" WHEN "10", -- Dime
           "000000011001" WHEN "11", -- Quarter
           "000000000000" WHEN OTHERS;
     
end data_flow;
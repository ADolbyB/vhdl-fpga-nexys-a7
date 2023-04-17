-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Coin List Entity For The Vending Machine

-- COIN LIST
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity coin_list is
    PORT(
        coin_sel : in std_logic_vector(1 downto 0);
        coin_amt : out std_logic_vector(11 downto 0)
    );
end coin_list;

architecture data_flow of coin_list is
    
    signal COIN_SIG : unsigned(11 downto 0) := X"000";

begin
    
    WITH coin_sel SELECT
        COIN_SIG <= X"001" WHEN "00", -- Penny
                    X"005" WHEN "01", -- Nickel
                    X"00A" WHEN "10", -- Dime
                    X"019" WHEN "11", -- Quarter
                    X"000" WHEN OTHERS;
     
     coin_amt <= std_logic_vector(COIN_SIG);
     
end data_flow;
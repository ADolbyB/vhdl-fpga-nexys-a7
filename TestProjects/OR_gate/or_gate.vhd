-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- OR gate test program

library IEEE;
use IEEE.std_logic_1164.all;

entity or_gate is
    Port (
        a : in std_logic;
        b : in std_logic;
        c : out std_logic
    );
end or_gate;

architecture behavioral of or_gate is

begin

    c <= a OR b;

end behavioral;
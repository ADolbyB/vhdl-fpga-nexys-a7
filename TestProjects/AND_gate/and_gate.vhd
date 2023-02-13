-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- AND gate test program

library IEEE;
use IEEE.std_logic_1164.all;

entity and_gate is
    Port (
        a : in std_logic;
        b : in std_logic;
        c : out std_logic
    );
end and_gate;

architecture behavioral of and_gate is

begin
    c <= a AND b;

end behavioral;
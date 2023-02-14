-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a really creative example of 8 bit parity logic
-- Same 7 XOR gates in series

library IEEE;
use ieee.std_logic_1164.all;

entity parity4_8bit is
    port (
        parity_in : IN std_logic_vector(7 downto 0); -- 8 bit signal in
        parity_out : OUT std_logic -- parity bit out
    );
end entity parity4_8bit;

architecture dataflow of parity4_8bit is
    signal xor_out : std_logic_vector(7 downto 0);
begin
    xor_out(0) <= parity_in(0);
    
    G2 : for i in 1 to 7 GENERATE
        xor_out(i) <= xor_out(i - 1) XOR parity_in(i);
    END GENERATE;
    
    parity_out <= xor_out(7);
end architecture dataflow;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an alternate example of 8 bit parity logic
-- 7 XOR gates in series

library IEEE;
use ieee.std_logic_1164.all;

entity parity2_8bit is
    port (
        parity_in : IN std_logic_vector(7 downto 0); -- 8 bit signal in
        parity_out : OUT std_logic -- parity bit out
    );
end entity parity2_8bit;

architecture dataflow of parity2_8bit is
    signal xor_out : std_logic_vector(6 downto 1); -- 7 bits for intermediate signals
begin
    xor_out(0) <= parity_in(0);
    xor_out(1) <= xor_out(0) XOR parity_in(1);
    xor_out(2) <= xor_out(1) XOR parity_in(2);
    xor_out(3) <= xor_out(2) XOR parity_in(3);
    xor_out(4) <= xor_out(3) XOR parity_in(4);
    xor_out(5) <= xor_out(4) XOR parity_in(5);
    xor_out(6) <= xor_out(5) XOR parity_in(6);
    xor_out(7) <= xor_out(6) XOR parity_in(7);
    parity_out <= xor_out(7);

end architecture dataflow;
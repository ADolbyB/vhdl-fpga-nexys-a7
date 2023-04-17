-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an 8 bit parity logic circuit using FOR / GENERATE statements
-- 7 XOR gates in series

library IEEE;
use ieee.std_logic_1164.all;

entity parity3_8bit is
    port (
        parity_in : IN std_logic_vector(7 downto 0); -- 8 bit signal in
        parity_out : OUT std_logic -- parity bit out
    );
end entity parity3_8bit;

architecture dataflow of parity3_8bit is
    signal xor_out : std_logic_vector(6 downto 1);
begin
    G2 : for i in 1 to 7 GENERATE
        left_xor : if i = 1 GENERATE
            xor_out(i) <= parity_in(i - 1) XOR parity_in(i);
        END GENERATE;
        middle_xor : if (i > 1) AND (i < 7) GENERATE
            xor_out(i) <= xor_out(i - 1) XOR parity_in(i);
        END GENERATE;
        right_xor : if i = 7 GENERATE
            parity_out <= xor_out(i - 1) XOR parity_in(i);
        END GENERATE;
    END GENERATE;    
end architecture dataflow;
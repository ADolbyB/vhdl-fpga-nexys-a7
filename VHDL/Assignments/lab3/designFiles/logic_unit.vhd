-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file is for the Logic Unit.
-- This performs BITWISE operations (Not Logical) with A and B and returns LOGIC_OUT.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic_unit is
    generic (N: integer := 6);
    port (
        A, B : IN std_logic_vector(N-1 downto 0);       -- 6 bit input signals
        SEL : IN std_logic_vector(1 downto 0);          -- 2 bit selects Logic Operation
        LOGIC_OUT : OUT std_logic_vector(N-1 downto 0)  -- 6 bit output signal
    );
end logic_unit;

architecture dataflow of logic_unit is
    -- define signals to store the temp results
begin
    WITH SEL SELECT
        LOGIC_OUT <= NOT A when "00",
                     A AND B when "01",
                     A OR B when "10",
                     A XOR B when "11",
                     "000000" when OTHERS;

end dataflow;
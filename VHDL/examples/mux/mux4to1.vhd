-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a DATAFLOW example of a 4to1 mux.
-- Demostrates use of WITH/SELECT parallel logic

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY mux4to1 IS
    PORT(
        w0 : IN STD_LOGIC;
        w1 : IN STD_LOGIC;
        w2 : IN STD_LOGIC;
        w3 : IN STD_LOGIC;
        s : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bit signal selector [ 1 = MSB, 0 = LSB ]
        f : OUT STD_LOGIC
    );
END ENTITY mux4to1;

architecture dataflow OF mux4to1 IS
begin
    -- Parallel Logic: all have equal priority
    WITH s SELECT
        f <= w0 WHEN "00", -- double quotes when more than 1 bit signal
             w1 WHEN "01",
             w2 WHEN "10",
             w3 WHEN OTHERS;

end dataflow;
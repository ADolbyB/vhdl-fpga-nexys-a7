-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a DATAFLOW example of a 4to1 mux.
-- Demostrates use of WITH/SELECT parallel logic

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY mux4to1_1 IS
    PORT(
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        C : IN STD_LOGIC;
        D : IN STD_LOGIC;
        SEL : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bit signal selector: 1 = MSB, 0 = LSB
        Z : OUT STD_LOGIC
    );
END ENTITY mux4to1_1;

architecture dataflow OF mux4to1_1 IS
begin
    -- Parallel Logic: all have equal priority
    WITH SEL SELECT
        Z <= A WHEN "00", -- double quotes when more than 1 bit signal
             B WHEN "01",
             C WHEN "10",
             D WHEN "11",
             '0' WHEN OTHERS; -- Default statement

end dataflow;
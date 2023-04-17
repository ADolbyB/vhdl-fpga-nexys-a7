-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This program implements a Full Adder
-- AB = (A XOR B);
-- SUM = (AB XOR CIN);
-- COUT = B WHEN AB = 0, ELSE COUT = CIN

library ieee;
use ieee.std_logic_1164.all;

ENTITY full_adder is
    PORT(
        A : IN STD_LOGIC;     -- 1 bit input and output for each adder instance
        B : IN STD_LOGIC;
        CIN : IN STD_LOGIC;   -- Carry In Bit
        COUT : OUT STD_LOGIC; -- Carry Out Bit
        SUM : OUT STD_LOGIC
    );
END ENTITY full_adder;

architecture dataflow OF full_adder is
    -- Define Intermediate Signal
    signal A_B : STD_LOGIC;
begin

    A_B <= A XOR B; 
    SUM <= A_B XOR CIN;
    COUT <= (A AND B) OR (A_B AND CIN);
    
end dataflow;
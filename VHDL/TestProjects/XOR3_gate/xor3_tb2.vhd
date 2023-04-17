-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Behavioral Test Bench for 3 input XOR gate
-- This code is more concise and generates input values

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity xor3_tb2 is
    -- No Component Entities in Test Bench programs
end xor3_tb2;

architecture behavioral of xor3_tb2 is
    -- Stimulus Signals: signals mapped to the input and input ports of tested entity
    signal test_vector : std_logic_vector(2 DOWNTO 0) := "000"; -- 1st test input declared here
    signal test_result : std_logic;    
begin
    UUT : entity work.xor3(dataflow) -- xor3 declaration in 'WORK' folder
        PORT MAP (
            A => test_vector(2),
            B => test_vector(1),
            C => test_vector(0),
            RESULT => test_result
        );
    Testing : process
    begin
        WAIT FOR 10 ns;
        test_vector <= test_vector + 1; -- generates all values "000" to "111"
    end process Testing;
end behavioral;
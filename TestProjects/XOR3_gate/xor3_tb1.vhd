-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Behavioral Test Bench for 3 input XOR gate

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity xor3_tb1 is
    -- No Component Entities in Test Bench programs
end xor3_tb1;

architecture behavioral of xor3_tb1 is
    -- Stimulus Signals: signals mapped to the input and input ports of tested entity
    signal test_vector : std_logic_vector(2 DOWNTO 0); -- 3 bits for 3 inputs
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
        test_vector <= "000";
        WAIT FOR 10 ns;
        test_vector <= "001";
        WAIT FOR 10 ns;
        test_vector <= "010";
        WAIT FOR 10 ns;
        test_vector <= "011";
        WAIT FOR 10 ns;
        test_vector <= "100";
        WAIT FOR 10 ns;
        test_vector <= "101";
        WAIT FOR 10 ns;
        test_vector <= "110";
        WAIT FOR 10 ns;
        test_vector <= "111";
        WAIT FOR 10 ns;
    end process Testing;
end behavioral;
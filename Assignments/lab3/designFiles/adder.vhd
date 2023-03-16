-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the adder component for the ALU.
-- It Performs operations on A and B and returns ADDER_OUT

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
generic(N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0);
        SEL : IN std_logic_vector(1 downto 0);
        ADDER_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end entity;

architecture dataflow of adder is
    
    -- Create Temporary Signals
    signal A_Long : unsigned(N downto 0);        -- Extra Bit for Carry Where Needed
    signal B_Long : unsigned(N downto 0);        -- Extra Bit for Carry Where Needed
    signal B_Compliment : signed(N downto 0);    -- Extra Bit for Carry Where Needed
    signal Add_Temp : unsigned(N downto 0);      -- 7 bit long that performs A_Long + B_Long
    signal Subtract_Temp : signed(N downto 0);   -- A_Long + B_Compliment
    signal Carry_Temp : unsigned(N-1 downto 0);  -- "00000" & Add_Temp MSB
    signal Borrow_Temp : unsigned(N-1 downto 0); -- "00000" & Subtract_Temp MSB
    
begin
    
    -- Signal Assignment
    A_Long <= '0' & unsigned(A); -- A_Long is 7 bits to hold a Carry if needed
    B_Long <= '0' & unsigned(B); -- B_Long is 7 bits
    
    -- ADDER FUNCTION
    Add_Temp <= A_Long + B_Long; -- Unsigned Addition of 7 bit A & B Can Contain the Carry

    -- CARRY FUNCTION
    Carry_Temp <= "00000" & Add_Temp(6); -- MSB of Add_Temp is the Carry Bit
    
    -- SUBTRACTION FUNCTION
    B_Compliment <= (NOT signed(B_Long)) + 1;       -- 2's Compliment for Subtraction
    Subtract_Temp <= signed(A_Long) + B_Compliment; -- A + (-B) = A - B
    
    -- BORROW FUNCTION
    Borrow_Temp <= "00000" & Subtract_Temp(6); -- MSB of Subtract_Temp is the Borrow Bit
    
    with SEL SELECT -- 6 bit outputs
        ADDER_OUT <= std_logic_vector(Add_Temp(N-1 downto 0)) when "00",
                     std_logic_vector(Carry_Temp(N-1 downto 0)) when "01",
                     std_logic_vector(Subtract_Temp(N-1 downto 0)) when "10",
                     std_logic_vector(Borrow_Temp(N-1 downto 0)) when "11",
                     "000000" when OTHERS;

end dataflow;
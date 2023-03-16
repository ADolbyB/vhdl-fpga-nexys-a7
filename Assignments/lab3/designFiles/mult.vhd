-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the file for the Multiplier.
-- This performs an n-bit binary times an n-bit binary operation.
-- This results in a 2n bit result
-- either the 6 high bits or 6 low bits are returned to MULT_OUT

library IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all; -- CONV_STD_LOGIC_VECTOR Function
--use ieee.numeric_std.all;

entity mult is
    GENERIC (N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0);
        SEL : IN std_logic; -- Only need one bit since there are only 2 possible operations
        MULT_OUT : OUT std_logic_vector(N-1 downto 0)
    );
end mult;

architecture dataflow of mult is

    SIGNAL total_result : unsigned(11 downto 0); -- 12 bit long result
    SIGNAL high_result : unsigned(N-1 downto 0); -- MSB 6 bits
    SIGNAL low_result : unsigned(N-1 downto 0);  -- LSB 6 bits

    --SIGNAL A_Unsigned : unsigned(N-1 downto 0); 
    --SIGNAL B_Unsigned : unsigned(N-1 downto 0);

    -- Use unsigned data representation for the computation of the result.
    -- Define Signals in Unsiged Form
    -- Define signals for the temp_results high, low_result
    -- compute the long multiplication, split and assign to temp signals.

begin

    --A_Unsigned <= unsigned(A); -- Cast A as an Unsigned and Assign to signal A_Unsigned
    --B_Unsigned <= unsigned(B); -- Cast B as an Unsigned and Assign to signal B_Unsigned

    total_result <= unsigned(A) * unsigned(B);   -- Perform Unsigned Multiplication
    -- total_result <= std_logic_vector(total_result(11 downto 0));
    
    high_result <= total_result(2*N-1 downto N); -- 2N-1 = 11, N = 6
    low_result <= total_result(N-1 downto 0);    -- N-1 = 5

    MULT_OUT <= std_logic_vector(high_result(N-1 downto 0)) -- Return Upper 6 bits
        WHEN SEL = '1' 
        ELSE std_logic_vector(low_result(N-1 downto 0));    -- Return Lower 6 bits

end dataflow;
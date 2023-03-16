-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file is for the bit shifter. 
-- The Shifter takes a 6 bit input A and 3 bit input B.
-- Logic Shift Left:
    -- If SEL = "00" or "01", then SHIFT_OUT becomes A shifted LEFT by B bits.
-- Logic Shift Right:
    -- If SEL = "10", then SHIFT_OUT becomes A shifted RIGHT by B bits.
-- Arithmetic Shift Right:
    -- If SEL = "11", then SHIFT_OUT becomes A shifted RIGHT by B bits. MSB of A is preserves.
-- Note that B is only 3 bits, so the maximum bits that can be shifted is 111 or 7 bits.


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- SHIFT_LEFT, SHIFT_RIGHT & TO_INTEGER Functions

entity shifter is
    generic(
        N : integer := 6;
        M : integer := 3
    );
    PORT(
        A : IN std_logic_vector(N-1 downto 0); -- 6 bits for input A
        B : IN std_logic_vector(M-1 downto 0); -- 3 bits for input B
        SEL : IN std_logic_vector(1 downto 0);
        SHIFT_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end entity;

architecture dataflow of shifter is
    
    SIGNAL A_Unsigned : unsigned(N-1 downto 0);
    SIGNAL A_Signed : signed(N-1 downto 0);
    SIGNAL B_Integer : integer range 0 to 7;
    
    SIGNAL Logic_Left : std_logic_vector(N-1 downto 0); 
    SIGNAL Logic_Right : std_logic_vector(N-1 downto 0);
    SIGNAL Arith_Right : std_logic_vector(N-1 downto 0);

begin

    B_Integer <= to_integer(unsigned(B)); -- B Becomes 3 in this case
    A_Signed <= signed(A);
    A_Unsigned <= unsigned(A);
    
    Logic_Left <= std_logic_vector(shift_left(A_Unsigned, B_Integer));
    Logic_Right <= std_logic_vector(shift_right(A_Unsigned, B_Integer));
    Arith_Right <= std_logic_vector(shift_right(A_signed, B_Integer));

    WITH SEL SELECT
        SHIFT_OUT <= Logic_Left WHEN "00",     -- Logic Shift Left
                        Logic_Left WHEN "01",  -- Logic Shift Left
                        Logic_Right WHEN "10", -- Logic Shift Right
                        Arith_Right WHEN "11", -- Arith Shift Right
                        "000000" WHEN OTHERS;  -- Default Case

end dataflow;
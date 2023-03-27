-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the file for the Carry-Save Multiplier Entity
-- This incorporates an N by N array of AND gates
-- And an N by N-1 array of Full Adders

library ieee;
use ieee.std_logic_1164.all;

entity carry_save_mult is
    GENERIC (N : integer : 8); -- N = Size of operands
    PORT(
        A : IN std_logic_vector(N-1 downto 0);
        B : IN std_logic_vector(N-1 downto 0);
        PRODUCT : OUT std_logic_vector(2N-1 downto 0) -- n bit * n bit = 2n bit result
    );
end carry_save_mult;

architecture behavioral of carry_save_mult is

    Signal FA_a, FA_b, FA_cin : (N-1 downto 0, N downto 0);
    Signal FA_sum, FA_cout : (N-1 downto 0, N downto 0);

begin
    -- Row 0 Of Adders
    FA_a(0) <= '0' & AB(0)(N-1 downto 0); -- Input A
    FA_b(0) <= AB(1)(N-1 downto 0); -- Input B
    FA_cin(0) <= AB(2)(N-2 downto 0) & '0'; -- Carry In

    -- Intermediate Rows 1 to N-3 (need an array)
    FA_a(i) <= AB(i+1)(N-1) & FA_sum(i-1)(N-1 downto 1);
    FA_b(i) <= FA_cout(i-1)(N-1 downto 0);
    FA_cin(i) <= AB(i+2)(N-2 downto 0) & '0';

    -- Last Row N-2 of Adders
    FA_a(N-2) <= AB(N-1)(N-1) & FA_sum(N-3)(N-1 downto 1);
    FA_b(N-2) <= FA_cout(N-3)(N-1 downto 0);
    FA_cin(N-2) <= AB(N-2)(N-2 downto 0) & '0';

end behavioral;
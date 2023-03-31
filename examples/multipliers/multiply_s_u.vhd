-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an implementation for a SIGNED & UNSIGNED Multiplier
-- Note that n-bit x n-bit = 2n bit result

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- library

entity multiply_s is
    generic(N : integer := 8)   -- 8 bit multiplication
    port(
        A : IN std_logic_vector(N-1 downto 0);
        B : IN std_logic_vector(N-1 downto 0);
        PROD_S : OUT std_logic_vector(2*N-1 downto 0); -- 16 bit SIGNED result
        PROD_U : OUT std_logic_vector(2*N-1 downto 0); -- 16 bit UNSIGNED result
    );
END multiply_s;

architecture dataflow of multiply_s is
begin
    
    -- Signed Multiplication
    PROD_S <= std_logic_vector(signed(A) * signed(B));

    -- Unsigned Multiplication
    PROD_U <= std_logic_vector(unsigned(A) * unsigned(B));

end dataflow;
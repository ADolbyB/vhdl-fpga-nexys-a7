-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an implementation for UNSIGNED Multiplication
-- Note that n-bit x n-bit = 2n bit result

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- UNSIGNED library

entity multiply_u is
    generic(N : integer := 8)   -- 8 bit multiplication
    port(
        A : IN std_logic_vector(N-1 downto 0);
        B : IN std_logic_vector(N-1 downto 0);
        PROD : OUT std_logic_vector(2*N-1 downto 0); -- 16 bit result
    );
END multiply_u;

architecture dataflow of multiply_u is
begin
    
    PROD <= A * B;

end dataflow;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 16to1 mux example using a cascade of 4to1 muxes.
-- This example uses standard structural PORT MAP type coding.

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY mux16to1 IS
    PORT(
        W : IN std_logic_vector(0 to 15); -- 16 bit MUX
        SEL : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 bits total signal selector in the cascade
        F : OUT STD_LOGIC
    );
END ENTITY mux16to1;

architecture structure of mux16to1 is
    -- instantiation of the 4to1 MUX for cascading
    component mux4to1
        port (
            W0, W1, W2, W3 : IN std_logic;
            SEL : IN std_logic_vector(1 DOWNTO 0); -- each mux has 2 bit selector
            F : OUT std_logic
        );
    end component;

    signal M : std_logic_vector(0 TO 3);

begin

    MUX1 : mux4to1 PORT MAP ( W(0), W(1), W(2), W(3), SEL(1 DOWNTO 0), M(0) ); -- MUX1 - MUX4 for inputs
    MUX2 : mux4to1 PORT MAP ( W(4), W(5), W(6), W(7), SEL(1 DOWNTO 0), M(1) );
    MUX3 : mux4to1 PORT MAP ( W(8), W(9), W(10), W(11), SEL(1 DOWNTO 0), M(2) );
    MUX4 : mux4to1 PORT MAP ( W(12), W(13), W(14), W(15), SEL(1 DOWNTO 0), M(3) );
    MUX5 : mux4to1 PORT MAP ( M(0), M(1), M(2), M(3), SEL(3 DOWNTO 2), F); -- Final MUX With output

end structure;
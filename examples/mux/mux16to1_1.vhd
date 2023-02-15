-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 16to1 mux example using a cascade of 4to1 muxes.
-- This example uses FOR / GENERATE to generate the 1st 4 MUX instances.

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY mux16to1_1 IS
    PORT(
        W : IN std_logic_vector(0 to 15); -- 16 bit MUX
        SEL : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 bits total signal selector in the cascade
        F : OUT STD_LOGIC
    );
END ENTITY mux16to1_1;

architecture structure of mux16to1_1 is
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

    G1 : FOR i in 0 TO 3 GENERATE -- Generate 1st 4 MUXes (identical select signals)
    MUXES : mux4to1
        PORT MAP (
            W(4 * i), W(4 * i + 1), W(4 * i + 2), W(4 * i + 3), SEL(1 DOWNTO 0), M(i)
        );
    END GENERATE;
    MUX5 : mux4to1 PORT MAP ( M(0), M(1), M(2), M(3), SEL(3 DOWNTO 2), F); -- Final MUX With output

end structure;
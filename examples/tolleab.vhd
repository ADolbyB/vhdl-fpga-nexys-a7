-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Example program using an upper-level hierarchy design
-- and a component declaration for a lower level design.

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY tolleab IS -- Upper level Block
    PORT (
        tclk, tcross, tnickel, tdime, tquarter : IN std_logic;
        tgreen, tred : OUT std_logic
    );
END ENTITY tolleab;

ARCHITECTURE tolleab_arch OF tolleab IS
    -- Component Declaration of tollv and its ports
    component tollv
        PORT(
            clk, cross, nickel, dime, quarter : IN std_logic;
            green, red : OUT std_logic
        );
    END component;

BEGIN
    -- Instantiation
    -- Lower Level block declares instance 'U1' and the port mapping to
    -- all the upper level signals
    U1 : tollv PORT MAP (
        clk => tclk, cross => tcross, nickel => tnickel, dime => tdime,
        quarter => tquarter, green => tgreen, red => tred
        );

END ARCHITECTURE tolleab_arch;
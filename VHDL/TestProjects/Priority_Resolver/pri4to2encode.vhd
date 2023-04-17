-- Joel Brigida
-- CDA4240C: Digital Design Lab
-- This is a component file for the Priority Resolver
-- Priority 4to2 encoder

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY pri4to2encode IS
    PORT(
        W : IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- 4 bit input
        Y : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bit output
        Z : OUT STD_LOGIC
    );
END ENTITY pri4to2encode;

architecture dataflow OF pri4to2encode IS

begin
    Y <= "11" WHEN W(3) = '1' ELSE
         "10" WHEN W(2) = '1' ELSE
         "01" WHEN W(1) = '1' ELSE
         "00";
    Z <= '0' WHEN W = "0000" ELSE '1';

end dataflow;
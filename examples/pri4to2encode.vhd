library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY pri4to2encode IS
    PORT(
        w : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 bit input
        y : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bit output
        z : OUT STD_LOGIC
    );
END ENTITY pri4to2encode;

architecture dataflow OF pri4to2encode IS

begin
    y <= "11" WHEN w(3) = '1' ELSE
         "10" WHEN w(2) = '1' ELSE
         "01" WHEN w(1) = '1' ELSE
         "00";
    z <= '0' WHEN w = "0000" ELSE '1';

end dataflow;
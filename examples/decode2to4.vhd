library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY decode2to4 IS
    PORT(
        w : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bit bus w in
        En : IN STD_LOGIC;
        y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- 4 bit bus y out
    );
end ENTITY decode2to4;

architecture dataflow OF decode2to4 IS
    SIGNAL ENw : STD_LOGIC_VECTOR(2 DOWNTO 0);

begin
    Enw <= En & w; -- MSB = En, LSB = w
    WITH Enw SELECT
        y <= "0001" WHEN "100",
             "0010" WHEN "101",
             "0100" WHEN "110",
             "1000" WHEN "111",
             "0000" WHEN OTHERS;
end dataflow;
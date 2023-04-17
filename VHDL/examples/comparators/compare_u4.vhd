-- Compares a 4 bit channel A to a 4 bit Channel B
-- Produces a 1 bit output on one of 3 channels

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package
use ieee.std_logic_unsigned.all; -- Use UNSIGNED integer library

ENTITY compare_u4 IS
    PORT(
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 bit bus: channel A in
        B : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 bit bus: channel B in
        AeqB : OUT STD_LOGIC; -- If A == B (1 bit OUT)
        AgtB : OUT STD_LOGIC; -- If A > B  (1 bit OUT)
        AltB : OUT STD_LOGIC  -- If A < B  (1 bit OUT)
    );
END ENTITY compare_u4;

architecture dataflow OF compare_u4 IS

begin

    AeqB <= '1' WHEN A = B ELSE '0'; -- Turn off output unless A == B
    AgtB <= '1' WHEN A > B ELSE '0';
    AltB <= '1' WHEN A < B ELSE '0';

end architecture;
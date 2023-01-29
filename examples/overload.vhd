-- Joel Brigida
-- CDA 4240C: Digital Design Lab

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package
use ieee.std_logic_unsigned.all; -- Use UNSIGNED integer library

ENTITY overload IS
    PORT (
        a : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- 1st 5 bit input (signal a)
        b : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- 2nd 5 bit input (signal b)
        sum : OUT STD_LOGIC_VECTOR (4 DOWNTO 0) -- 5 bit output signal
    );
END ENTITY overload;

ARCHITECTURE example OF overload IS

BEGIN

    -- UNSIGNED library allows us to perform arithmetic on non-built-in data types
    sum <= a + b;

END ARCHITECTURE example;
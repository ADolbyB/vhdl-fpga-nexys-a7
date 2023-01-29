-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Program a counter / accumulator that always adds a '1'
-- Uses a D Flip Flop

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package
use ieee.std_logic_unsigned.all;

entity counter is
    port (
        clk, rst : in std_logic;
        q : out std_logic_vector(15 DOWNTO 0) -- 16 bit signal        
    );
end entity counter;

ARCHITECTURE logic OF counter IS
    SIGNAL tmp_q : std_logic_vector(15 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '0' THEN
            tmp_q <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            tmp_q <= tmp_q + 1;
        END IF;
    END PROCESS;
    q <= tmp_q;
END ARCHITECTURE logic;
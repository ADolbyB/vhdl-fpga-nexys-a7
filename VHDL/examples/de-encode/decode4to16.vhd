-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a 4to16 decoder example using a cascade of 2to4 decoder.
-- This example uses FOR / GENERATE to generate the 1st 4 decoder instances.

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY decode4to16 IS
    PORT(
        W : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4 bit signal in
        EN : IN STD_LOGIC;
        Y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- 16 bit signal out
    );
end ENTITY decode4to16;

architecture structure OF decode4to16 IS
    -- instantiate component to generate multiple instances
    component decode2to4 is
        port (
            W : in std_logic_vector(1 DOWNTO 0);
            EN : in std_logic;
            Y : out std_logic_vector(3 DOWNTO 0)
        );
    end component;
    -- Intermediate Signals between component and wrapper
    SIGNAL M : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
    -- Generate 4 instances of 4to16 decoders
    G1 : FOR i in 0 to 3 GENERATE
        DEC_RIGHT : decode2to4
            PORT MAP (
                W(1 DOWNTO 0), M(i), Y(4 * i + 3 DOWNTO 4 * i)
            );
        END GENERATE;
    DEC_LEFT : decode2to4
        PORT MAP (
            W(3 DOWNTO 2), EN, M
        );
end structure;
library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY mux_cascade IS
    PORT (
        w1, w2, w3 : IN STD_LOGIC;
        s1, s2 : IN STD_LOGIC;
        f : OUT STD_LOGIC
    );
END ENTITY mux_cascade;
    
architecture dataflow OF mux_cascade is

begin
    
    f <= w1 WHEN s1 = '1' else
         w2 WHEN s2 = '1' else
         w3;

end dataflow;
library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY mux2to1 is
    PORT(
        w0 : IN STD_LOGIC;
        w1 : IN STD_LOGIC;
        s : IN STD_LOGIC;
        f : OUT STD_LOGIC
    );
END ENTITY mux2to1;

architecture dataflow OF mux2to1 is
begin
    f <= w0 WHEN s = '0' ELSE w1;
end dataflow;
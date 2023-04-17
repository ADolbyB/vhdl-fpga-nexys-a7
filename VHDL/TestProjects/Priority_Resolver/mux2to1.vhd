-- Joel Brigida
-- CDA4240C: Digital Design Lab
-- This is a component file for the Priority Resolver
-- 2to1 Multiplexer

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY mux2to1 is
    PORT(
        W0 : IN STD_LOGIC;
        W1 : IN STD_LOGIC;
        S : IN STD_LOGIC;
        F : OUT STD_LOGIC
    );
END ENTITY mux2to1;

architecture dataflow OF mux2to1 is
begin
    F <= W0 WHEN S = '0' ELSE W1;
end dataflow;
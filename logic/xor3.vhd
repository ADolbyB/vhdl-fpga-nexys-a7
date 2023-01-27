library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY xor3 is
    PORT(
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        C : IN STD_LOGIC;
        Y : OUT STD_LOGIC
    );
end xor3;

architecture dataflow OF xor3 is
begin
    
    Y <= A XOR B XOR C;
    
end dataflow;
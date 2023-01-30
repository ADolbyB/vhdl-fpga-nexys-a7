library ieee;
use ieee.std_logic_1164.all;

ENTITY xor2 is
    PORT(
        I1 : IN STD_LOGIC;
        I2 : IN STD_LOGIC;
        Y : OUT STD_LOGIC
    );
END ENTITY xor2;

architecture dataflow OF xor2 is
begin
    
    Y <= I1 xor I2;
    
end dataflow;
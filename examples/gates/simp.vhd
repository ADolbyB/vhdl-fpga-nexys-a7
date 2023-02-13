-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Handmade NAND gate...the hard way
-- Simple 2 input AND with the output NOTTED

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package
use ieee.std_logic_signed.all; -- Use SIGNED integer library

ENTITY simp IS
    PORT (
        i1, i2 : IN BIT;
        o : OUT BIT
    );
END ENTITY simp;

ARCHITECTURE logic OF simp IS
    SIGNAL int : BIT;
BEGIN
    int <= i1 AND i2;
    o <= NOT int;
END ARCHITECTURE logic;
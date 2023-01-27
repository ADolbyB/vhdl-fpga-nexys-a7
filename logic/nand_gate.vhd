library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY nand_gate is
    PORT(
        a : IN STD_LOGIC; -- Port Modes
        b : IN STD_LOGIC;
        z : OUT STD_LOGIC -- No Semi Colon Here
    );
END nand_gate;

architecture model of nand_gate is

begin
    z <= a NAND b;
end model;
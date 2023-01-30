library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

architecture structural OF xor3_gate IS

SIGNAL U1_OUT : STD_LOGIC;

COMPONENT xor2 IS 
    PORT(
        I1 : IN STD_LOGIC;
        I2 : IN STD_LOGIC;
        Y : OUT STD_LOGIC
    );
END COMPONENT;

begin -- Uses 2 xor2 gates to make an xor3 gate

    U1 : xor2 PORT MAP (I1 => A,
                        I2 => B,
                        Y => U1_OUT);

    U2 : xor2 PORT MAP (I1 => U1_OUT,
                        I2 => C,
                        Y => Result);

end structural;
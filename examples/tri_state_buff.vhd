-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a DATAFLOW example of a tri-state buffer using PRIORITY logic
-- Demostrates use of WHEN/ELSE priority logic

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY tri_state_buff IS
    PORT(
        cnt : IN STD_LOGIC; -- Signal Controller
        drv : IN STD_LOGIC; -- Signal Driver
        out1 : OUT STD_LOGIC
    );
END ENTITY tri_state_buff;

architecture dataflow OF tri_state_buff IS
begin
    -- output is disconnected (high impedance) unless control is HIGH
    out1 <= drv WHEN (cnt = '1') ELSE 'Z';

end dataflow;
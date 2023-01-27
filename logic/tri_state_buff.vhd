library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY tri_state_buff IS
    PORT(
        e : IN STD_LOGIC;
        x : IN STD_LOGIC;
        f : OUT STD_LOGIC
    );
END tri_state_buff;

architecture dataflow OF tri_state_buff IS
begin
    
    f <= x WHEN (e = '1') ELSE 'Z';

end dataflow;
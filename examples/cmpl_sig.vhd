-- Joel Brigida
-- CDA 4240C: Digital Design Lab

library ieee; -- Library Package declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY cmpl_sig IS
    PORT(
        a, b, sel : IN BIT;
        x, y, z : OUT BIT
    );
END ENTITY cmpl_sig;

architecture logic OF cmpl_sig IS
begin
    -- This architecture defines 
    -- simple signal assignment
    x <= (a AND NOT sel) OR (b AND sel);

    -- conditional signal assignment
    y <= a WHEN sel = '0' ELSE b;
    
    -- Selected signal assignment
    WITH sel SELECT
        z <= a WHEN '0',
             b WHEN '1',
            '0' WHEN OTHERS;

END architecture logic;
 
configuration cmpl_sig_conf OF cmpl_sig IS
    FOR logic
    END FOR;
end configuration cmpl_sig_conf;
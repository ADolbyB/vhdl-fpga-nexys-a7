-- Joel Brigida
-- CDA 4240C: Digital Design Lab

library ieee; -- Library Package declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package
use ieee.numeric_std.all; -- Define SIGNED and UNSIGNED data types. 

PACKAGE filt_cmp IS
    TYPE state_type IS (idle, tap1, tap2, tap3, tap4);
    FUNCTION compare (variable a , b : integer) RETURN boolean;
END PACKAGE filt_cmp;

PACKAGE BODY filt_cmp IS
    FUNCTION compare (variable a , b : INTEGER) IS
        VARIABLE temp : BOOLEAN ;
    BEGIN
        IF a < b THEN
            temp := true ;
        else
            temp := false ;
        END IF ;
        RETURN temp ;
    END FUNCTION compare ;
END PACKAGE BODY filt_cmp ;
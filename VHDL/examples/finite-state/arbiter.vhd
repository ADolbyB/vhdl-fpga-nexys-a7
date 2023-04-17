-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a behavioral example of an Arbiter

library ieee;
use IEEE.std_logic_1164.all;

entity arbiter is
    port(
        CLOCK, RESET : in STD_LOGIC;
        R : IN STD_LOGIC_VECTOR(1 to 3);
        G : OUT STD_LOGIC_VECTOR(1 to 3)
    );
end arbiter;

architecture behavior of arbiter is
    type state_type IS (IDLE, GNT1, GNT2, GNT3);
    SIGNAL Y : state_type;
begin
    PROCESS(RESET, CLOCK)
    BEGIN
        IF RESET = '1' THEN
            Y <= IDLE;
        ELSIF rising_edge(CLOCK) THEN
            CASE Y IS
                WHEN IDLE =>
                    IF R(1) = '1' THEN
                        Y <= GNT1;
                    ELSIF R(2) = '1' THEN
                        Y <= GNT2;
                    ELSIF R(3) = '1' THEN
                        Y <= GNT3;
                    ELSE
                        Y <= IDLE;
                    END IF;
                WHEN GNT1 =>
                    IF R(1) = '1' THEN
                        Y <= GNT1;
                    ELSE
                        Y <= IDLE;
                    END IF;
                WHEN GNT2 =>
                    IF R(2) = '1' THEN
                        Y <= GNT2;
                    ELSE 
                        Y <= IDLE;
                    END IF;
                WHEN GNT3 =>
                    IF R(3) = '1' THEN
                        Y <= GNT3;
                    ELSE
                        Y <= IDLE;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    G(1) <= '1' WHEN Y = GNT1 ELSE '0';
    G(2) <= '1' WHEN Y = GNT2 ELSE '0';
    G(3) <= '1' WHEN Y = GNT3 ELSE '0';    
    
end behavior;
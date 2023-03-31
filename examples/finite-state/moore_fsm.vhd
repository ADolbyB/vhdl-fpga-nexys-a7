-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a behavioral example of a Moore Finite State Machine
-- This example has 3 states to detect the sequence "10"

library ieee;
use IEEE.std_logic_1164.all;

entity moore_fsm is
    port(
        INPUT : in STD_LOGIC;
        CLOCK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        OUTPUT : out STD_LOGIC;
    );
end moore_fsm;

architecture behavioral of moore_fsm is
    
    TYPE state IS (S0, S1, S2);
    SIGNAL moore_state: state;

begin
    U_Moore : PROCESS(CLOCK, RESET)
    begin
        IF(RESET = '0') THEN
            moore_state <= S0;
        ELSIF rising_edge(CLOCK) THEN
            CASE moore_state IS
                WHEN S0 =>
                    IF INPUT = '1' THEN
                        moore_state <= S1;
                    ELSE
                        moore_state <= SO;
                    END IF;
                WHEN S1 =>
                    IF INPUT = '0' THEN
                        moore_state <= S2;
                    ELSE
                        moore_state <= S1;
                    END IF;
                WHEN S2 =>
                    IF INPUT = '0' THEN
                        moore_state <= S0;
                    ELSE
                        moore_state <= S1;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    OUTPUT <= '1' WHEN moore_state = S2 ELSE '0';

END behavioral;
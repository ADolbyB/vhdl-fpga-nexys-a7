-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a behavioral example of a Mealy Finite State Machine
-- This example has 2 states to detect the sequence "10"

library ieee;
use IEEE.std_logic_1164.all;

entity mealy_fsm is
    port(
        INPUT : in STD_LOGIC;
        CLOCK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        OUTPUT : out STD_LOGIC;
    );
end mealy_fsm;

architecture behavioral of mealy_fsm is
    
    TYPE state IS (S0, S1);
    SIGNAL mealy_state : state;

begin
    U_Mealy : PROCESS(CLOCK, RESET)
    begin
        IF(RESET = '0') THEN
            mealy_state <= S0;
        ELSIF rising_edge(CLOCK) THEN
            CASE mealy_state is
                WHEN S0 =>
                    IF INPUT = '1' THEN
                        mealy_state <= S1;
                    ELSE
                        mealy_state <= S0;
                    END IF;
                WHEN S1 =>
                    IF INPUT = '0' THEN
                        mealy_state <= S0;
                    ELSE
                        mealy_state <= S1;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    OUTPUT <= '1' WHEN(mealy_state = S1 AND INPUT = '0') ELSE '0';

end behavioral;
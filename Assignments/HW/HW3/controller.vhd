-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Code for Finite State Machine

library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY controller IS
    PORT( 
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        X : OUT STD_LOGIC;
        Y : OUT STD_LOGIC;
        Z : OUT STD_LOGIC
    );
END controller;

ARCHITECTURE mixed OF controller IS

TYPE FSM_state IS (S0, S1, S2, S3, S4);
SIGNAL State: FSM_state;

BEGIN
    
    FSM: PROCESS (clk, rst)
    BEGIN
        IF(rst = '1') THEN
            State <= S0;
        ELSIF rising_edge(clk) THEN
            CASE State IS
                WHEN S0 => 
                    IF a = '1' THEN
                        State <= S1;
                    ELSE
                        State <= S0;
                    END IF;
                WHEN S1 =>
                    State <= S2;
                WHEN S2 =>
                    IF a = '1' THEN
                        State <= S3;
                    ELSE
                        State <= S4;
                    END IF;
                WHEN S3 =>
                    IF b = '1' THEN
                        State <= S4;
                    ELSE
                        State <= S2;
                    END IF;
                WHEN S4 =>
                    IF a = '1' THEN
                        State <= S1;
                    ELSIF b = '1' THEN
                        State <= S3;
                    ELSE
                        State <= S0;
                    END IF;
            END CASE;
        END IF;
END PROCESS;
    
    X <= '1' WHEN
        (State = S1 and A = '0') OR (State = S2 and A = '1') OR (State = S4 and A = '0') 
        ELSE '0';
    
    Y <= '1' WHEN
        (State = S2) OR (State = S3 and B = '1') OR ( State = S4 )
        ELSE '0';
    
    Z <= '1' WHEN 
        (State = S1 and A = '0') OR (State = S2 and A = '0') OR 
        (State = S3 and B = '0') OR (State = S4 and A = '0' and B = '1') 
        ELSE '0';

END mixed;
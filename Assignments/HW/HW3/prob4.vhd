-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the solution to problem #4
-- Given the ASM Chart

library ieee;
use IEEE.std_logic_1164.all;

entity prob4 is
    port(
        RESET : in STD_LOGIC;
        CLOCK : in STD_LOGIC;
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        P : out STD_LOGIC;
        R : out STD_LOGIC;
        Y : out STD_LOGIC;
    );
end prob4;

architecture dataflow of prob4 is
    
    TYPE state IS (S0, S1, S2, S3, S4);
    SIGNAL my_state : state;

begin
    The_State : PROCESS(CLOCK, RESET)
    begin
        IF(RESET = '1') THEN
            my_state <= S0;
        ELSIF rising_edge(CLOCK) THEN
            CASE my_state is
                WHEN S0 =>
                    IF A = '0' THEN
                        my_state <= S0;
                    ELSE
                        my_state <= S1;
                    END IF;
                WHEN S1 =>
                    IF B = '1' THEN
                        my_state <= S1;
                    ELSE
                        my_state <= S2;
                    END IF;
                WHEN S2 =>
                    IF B = '0' THEN
                        my_state <= S2;
                    ELSE
                        my_state <= S3;
                    END IF;
                WHEN S3 =>
                    IF B = '0' THEN
                        my_state <= S2;
                    ELSE
                        my_state <= S4;
                    END IF;
                WHEN S4 =>
                    IF B = '1' THEN
                        my_state <= S1;
                    ELSIF B = '0' THEN
                        IF A = '1' THEN
                            my_state <= S2;
                        ELSE
                            my_state <= S0;
                        END IF;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    P <= '1' WHEN(my_state = S1) OR (my_state = S3) ELSE '0';
    R <= '1' WHEN(my_state = S1 AND B = '0') OR (my_state = S2 AND B = '1') 
             OR (my_state = S3 AND B = '1') OR (my_state = S4 AND B = '0') ELSE '0';
    Y <= '1' WHEN(my_state = S4 AND (B = '0' AND A = '1')) ELSE '0';

end dataflow;
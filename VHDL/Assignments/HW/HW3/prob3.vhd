-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the solution to problem #3
-- Given the ASM Chart

library ieee;
use IEEE.std_logic_1164.all;

entity prob3 is
    port(
        RESET : in STD_LOGIC;
        CLOCK : in STD_LOGIC;
        X : in STD_LOGIC;
        Y : in STD_LOGIC;
        V : out STD_LOGIC;
        Z : out STD_LOGIC;
        INIT : out STD_LOGIC;
        WRITE : out STD_LOGIC;
        LOAD : out STD_LOGIC
    );
end prob3;

architecture dataflow of prob3 is
    
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
                    IF X = '1' THEN
                        my_state <= S1;
                    ELSE
                        my_state <= S0;
                    END IF;
                WHEN S1 =>
                    IF X = '0' THEN
                        my_state <= S1;
                    ELSE
                        my_state <= S2;
                    END IF;
                WHEN S2 =>
                    IF Y = '0' THEN
                        my_state <= S4;
                    ELSE
                        my_state <= S3;
                    END IF;
                WHEN S3 =>
                    IF X = '1' THEN
                        my_state <= S4;
                    ELSIF X = '0' THEN
                        IF Y = '1' THEN
                            my_state <= S2;
                        ELSE
                            my_state <= S1;
                        END IF;
                    END IF;
                WHEN S4 =>
                    my_state <= S2;
            END CASE;
        END IF;
    END PROCESS;

    V <= '1' WHEN(my_state = S1 AND X = '0') OR (my_state = S2 AND Y = '0') ELSE '0';
    Z <= '1' WHEN(my_state = S3 AND (X = '0' AND Y = '0')) ELSE '0';
    INIT <= '1' WHEN(my_state = S0) ELSE '0';
    WRITE <= '1' WHEN(my_state = S3) ELSE '0';
    LOAD <= '1' WHEN(my_state = S4) ELSE '0';

end dataflow;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a serial adder Finite State Machine with 4 states
-- Operands A and B arrive 1 bit at a time with LSB first and the sum S is delivered in the same manner.

library ieee;
use IEEE.std_logic_1164.all;

entity serial_add_FSM is
    port(
        CLOCK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        SUM : out STD_LOGIC
    );
end serial_add_FSM;

architecture behavioral of serial_add_FSM is
    
    TYPE state_type is (S0, S1, S2, S3);
    SIGNAL D, Q : state_type;

begin
    -- State Register
    PROCESS(CLOCK, RESET)
        begin
            IF (RESET = '1') THEN
                Q <= S0;
            ELSIF rising_edge(CLOCK) THEN
                Q <= D;
            END IF;
    END PROCESS;

    -- Next State Decoder
    PROCESS(Q, A, B)
        begin
            CASE Q is
                WHEN S0 =>
                    IF A & B = "00" THEN
                        D <= S0;
                    ELSIF A & B = "11" THEN
                        D <= S2;
                    ELSE
                        D <= S1;
                    END IF;
                WHEN S1 => 
                    IF A & B = "00" THEN
                        D <= S0;
                    ELSIF A & B = "11" THEN
                        D <= S2;
                    ELSE
                        D <= S1;
                    END IF;
                WHEN S2 =>
                    IF A & B = "00" THEN
                        D <= S1;
                    ELSIF A & B = "11" THEN
                        D <= S3;
                    ELSE
                        D <= S2;
                    END IF;
                WHEN S3 =>
                    IF A & B = "00" THEN
                        D <= S1;
                    ELSIF A & B = "11" THEN
                        D <= S3;
                    ELSE
                        D <= S2;
                    END IF; 
            END CASE;
    END PROCESS;

    SUM <= '1' WHEN Q = S1 OR Q = S3 ELSE '0'; 

end behavioral;
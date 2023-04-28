-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an alternative implementation for a Multiple Input Signature Register

library ieee;
use ieee.std_logic_1164.all;

entity misr_1 is
    generic (C : std_logic_vector(7 downto 0));
    port (
        -- inputs
        CLK : in std_logic;
        RST : in std_logic;
        EN : in std_logic;
        D : in std_logic_vector (7 downto 0);
        -- outputs
        Q_OUT : out std_logic_vector (7 downto 0)
    );
END entity;

architecture mixed of misr_1 is
    
    -- intermediate signals
    signal Q : std_logic_vector (7 downto 0);
    signal Q0_replicated : std_logic_vector (7 downto 0);
    signal D_FF_IN : std_logic_vector (7 downto 0);

BEGIN
    
    Q0_replicated <= (OTHERS => Q(0)) ;
    D_FF_IN <= D XOR ('0' & Q(7 downto 1)) XOR (C and Q0_replicated);
    
    -- D flip flop operation
    D_FFs: PROCESS (RST, CLK)
        BEGIN
            IF (RST = '1') THEN
                Q <= (OTHERS => '0');
            ELSIF RISING_EDGE(CLK) THEN
                IF(EN = '1') THEN
                    Q <= D_FF_IN;
                END IF;
            END IF;
        END PROCESS;

    Q_OUT <= Q;

END mixed;
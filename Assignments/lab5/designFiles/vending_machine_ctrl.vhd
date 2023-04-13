-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Finite State Machine Controller for the Vending Machine Subsystem

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vending_machine_ctrl is
    Port ( 
            -- inputs
        clk            : in std_logic;
        rst            : in std_logic;
        lock           : in std_logic;
        soda_reserved  : in std_logic;
        soda_price     : in std_logic_vector(11 downto 0);
        soda_req       : in std_logic;
        deposit_amt    : in std_logic_vector(11 downto 0);
        coin_push      : in std_logic;
        coin_amt       : in std_logic_vector(11 downto 0);
            --outputs
        soda_drop      : out std_logic;
        deposit_incr   : out std_logic;
        deposit_decr   : out std_logic;
        coin_reject    : out std_logic;
        error_amt      : out std_logic;
        error_reserved : out std_logic
        );

end vending_machine_ctrl;

architecture Behavioral of vending_machine_ctrl is

    TYPE STATE IS (IDLE, COIN_ACCEPT, COIN_CHECK, COIN_DECLINE, SODA_ACCEPT_WAIT,
                   SODA_ACCEPT, SODA_CHECK, SODA_DECLINE_AMT, SODA_DECLINE_RESERVED);
    SIGNAL VEND_STATE : STATE;

begin
    -- Case Statements for Each State
    FSM_Vend : PROCESS(CLK, RST)
    BEGIN
        IF(rst = '0') THEN
            VEND_STATE <= IDLE;
        ELSIF rising_edge(CLK) THEN
            CASE VEND_STATE IS
                WHEN IDLE =>
                    IF soda_req = '1' THEN
                        VEND_STATE <= SODA_CHECK;
                    ELSIF coin_push = '1' THEN
                        VEND_STATE <= COIN_CHECK;
                    ELSE
                        VEND_STATE <= IDLE;
                    END IF;
                WHEN COIN_CHECK => -- $10.00 = 3E8 in hex 
                    IF unsigned(coin_amt) + unsigned(deposit_amt) <= X"3E8" THEN
                        VEND_STATE <= COIN_ACCEPT;
                    ELSE -- Deposit Amount > $10.00
                        VEND_STATE <= COIN_DECLINE;
                    END IF;
                WHEN COIN_ACCEPT =>
                    VEND_STATE <= IDLE;
                WHEN COIN_DECLINE =>
                    VEND_STATE <= IDLE;
                WHEN SODA_CHECK =>
                    IF soda_reserved = '1' THEN
                        VEND_STATE <= SODA_DECLINE_RESERVED;
                    ELSIF (deposit_amt >= soda_price) THEN
                        VEND_STATE <= SODA_ACCEPT;
                    ELSIF (deposit_amt <= soda_price) THEN
                        VEND_STATE <= SODA_DECLINE_AMT;
                    ELSE -- THIS SHOULD NOT HAPPEN
                        VEND_STATE <= IDLE; -- Prevent Hanging In Case of Invalid Input
                    END IF;
                WHEN SODA_DECLINE_AMT =>
                    IF lock = '0' THEN
                        VEND_STATE <= IDLE;
                    ELSE
                        VEND_STATE <= SODA_DECLINE_AMT; -- Do I need this??
                    END IF;
                WHEN SODA_DECLINE_RESERVED =>
                    IF lock = '0' THEN
                        VEND_STATE <= IDLE;
                    ELSE
                        VEND_STATE <= SODA_DECLINE_RESERVED; -- Do I need this??
                    END IF;
                WHEN SODA_ACCEPT =>
                    VEND_STATE <= SODA_ACCEPT_WAIT;
                WHEN SODA_ACCEPT_WAIT =>
                    IF lock = '0' THEN
                        VEND_STATE <= IDLE;
                    ELSE
                        VEND_STATE <= SODA_ACCEPT_WAIT; -- Do I need this??
                    END IF;
            END CASE;
        END IF;
    END PROCESS;

    -- Outputs For State Cases
    deposit_incr <= '1' WHEN (VEND_STATE = COIN_ACCEPT) ELSE '0';
    coin_reject <= '1' WHEN (VEND_STATE = COIN_DECLINE) ELSE '0';
    deposit_decr <= '1' WHEN (VEND_STATE = SODA_ACCEPT) ELSE '0';
    error_amt <= '1' WHEN (VEND_STATE = SODA_DECLINE_AMT) ELSE '0';
    soda_drop <= '1' WHEN (VEND_STATE = SODA_ACCEPT_WAIT) ELSE '0';
    error_reserved <= '1' WHEN (VEND_STATE = SODA_DECLINE_RESERVED) ELSE '0';

end Behavioral;
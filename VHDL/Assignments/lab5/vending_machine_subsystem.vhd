-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the complete Vending Machine Subsytem in a single file with all components.

-- SODA LIST
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soda_list is
    PORT(
        soda_sel      : in std_logic_vector(3 downto 0);
        soda_reserved : out std_logic;
        soda_price    : out std_logic_vector(11 downto 0)
    );
end soda_list;

architecture dataflow of soda_list is

begin

    WITH soda_sel SELECT soda_price
        <= X"037" WHEN "0000", -- Soda 0 = $0.55
           X"055" WHEN "0001", -- Soda 1 = $0.85
           X"05F" WHEN "0010", -- Soda 1 = $0.95
           X"07D" WHEN "0011", -- Soda 1 = $1.25
           X"087" WHEN "0100", -- Soda 1 = $1.35
           X"096" WHEN "0101", -- Soda 1 = $1.50
           X"0E1" WHEN "0110", -- Soda 1 = $2.25
           X"0FA" WHEN "0111", -- Soda 1 = $2.50
           X"12C" WHEN "1000", -- Soda 1 = $3.00
           X"000" WHEN OTHERS; -- Soda Reserved

    soda_reserved <= '1' WHEN unsigned(soda_sel) > 8 ELSE '0'; -- Set Soda Reserved Flag for Invalid Sodas.

end dataflow;


-- COIN LIST
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity coin_list is
    PORT(
        coin_sel : in std_logic_vector(1 downto 0);
        coin_amt : out std_logic_vector(11 downto 0)
    );
end coin_list;

architecture data_flow of coin_list is
    
    signal COIN_SIG : unsigned(11 downto 0) := X"000";

begin
    
    WITH coin_sel SELECT
        COIN_SIG <= X"001" WHEN "00", -- Penny
                    X"005" WHEN "01", -- Nickel
                    X"00A" WHEN "10", -- Dime
                    X"019" WHEN "11", -- Quarter
                    X"000" WHEN OTHERS;
     
     coin_amt <= std_logic_vector(COIN_SIG);
     
end data_flow;


-- DEPOSIT REGISTER: accounts the amount deposited OR Decremented in cents.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity deposit_register is
    Port ( 
        -- inputs
        clk      : in std_logic;
        rst      : in std_logic;    
        incr     : in std_logic;
        incr_amt : in std_logic_vector(11 downto 0);
        decr     : in std_logic;
        decr_amt : in std_logic_vector(11 downto 0);
        --outputs
        amt      : out std_logic_vector(11 downto 0)
    );
end deposit_register;

architecture Behavioral of deposit_register is

    SIGNAL TOTAL_AMT : std_logic_vector(11 downto 0) := X"000"; -- Set inital Total Amt to $0.00
    
begin
    
    DEP_REG : PROCESS(rst, clk)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (rst = '0') THEN
                amt <= X"000";                                                              -- Reset deposit Credit
                TOTAL_AMT <= X"000";           
            ELSIF (incr = '1') THEN
                TOTAL_AMT <= std_logic_vector(unsigned(TOTAL_AMT) + unsigned(incr_amt));    -- Update Total Amount Intermediate Value
                amt <= std_logic_vector(unsigned(TOTAL_AMT) + unsigned(incr_amt));          -- Update Output Amount
            ELSIF (decr = '1') THEN
                TOTAL_AMT <= std_logic_vector(unsigned(TOTAL_AMT) - unsigned(decr_amt));    -- Update Total Amount Intermediate Value
                amt <= std_logic_vector(unsigned(TOTAL_AMT) - unsigned(decr_amt));          -- Update Output Amount
            END IF;
        END IF;       
    END PROCESS;

end Behavioral;

-- FINITE STATE MACHINE
-- Note that when pushing a coin, the coin is rejected when the deposit amount exceeds $10.00
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
        IF rising_edge(CLK) THEN
            IF(rst = '0') THEN
                VEND_STATE <= IDLE;
            ELSE CASE VEND_STATE IS
                WHEN IDLE =>
                    IF coin_push = '1' THEN
                        VEND_STATE <= COIN_CHECK;
                    ELSIF soda_req = '1' THEN
                        VEND_STATE <= SODA_CHECK;
                    END IF;
                WHEN COIN_CHECK =>
                    IF unsigned(coin_amt) + unsigned(deposit_amt) > X"3E8" THEN
                        VEND_STATE <= COIN_DECLINE; -- $10.00 = 3E8 in hex 
                    ELSE
                        VEND_STATE <= COIN_ACCEPT;  -- Deposit Amount <= $10.00
                    END IF;
                WHEN COIN_ACCEPT =>
                    VEND_STATE <= IDLE;
                WHEN COIN_DECLINE =>
                    IF (lock = '0') THEN
                        VEND_STATE <= IDLE;
                    END IF;
                WHEN SODA_CHECK =>
                    IF soda_reserved = '1' THEN
                        VEND_STATE <= SODA_DECLINE_RESERVED;
                    ELSIF (deposit_amt >= soda_price) THEN
                        VEND_STATE <= SODA_ACCEPT;
                    ELSIF (deposit_amt < soda_price) THEN
                        VEND_STATE <= SODA_DECLINE_AMT;
                    END IF;
                WHEN SODA_DECLINE_AMT =>
                    IF lock = '0' THEN
                        VEND_STATE <= IDLE;
                    END IF;
                WHEN SODA_DECLINE_RESERVED =>
                    IF lock = '0' THEN
                        VEND_STATE <= IDLE;
                    END IF;
                WHEN SODA_ACCEPT =>
                    VEND_STATE <= SODA_ACCEPT_WAIT;
                WHEN SODA_ACCEPT_WAIT =>
                    IF lock = '0' THEN
                        VEND_STATE <= IDLE;
                    END IF;
                END CASE;
            END IF;
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


-- WRAPPER FOR SUBSYSTEM
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY vending_machine_subsystem is
    Port ( 
        -- inputs
        clk             : in std_logic;
        rst             : in std_logic;
        soda_sel        : in std_logic_vector(3 downto 0);
        soda_req        : in std_logic;
        lock            : in std_logic;
        coin_push       : in std_logic;
        coin_sel        : in std_logic_vector(1 downto 0);
        --outputs
        soda_reserved   : out std_logic;
        soda_price      : out std_logic_vector(11 downto 0);
        soda_drop       : out std_logic;
        error_amt       : out std_logic;
        error_reserved  : out std_logic;
        coin_reject     : out std_logic;
        deposit_amt     : out std_logic_vector(11 downto 0)
    );
END vending_machine_subsystem;

architecture Behavioral of vending_machine_subsystem is
    
    component soda_list is
        PORT(
            soda_sel      : in std_logic_vector(3 downto 0);
            soda_reserved : out std_logic;
            soda_price    : out std_logic_vector(11 downto 0)
        );
    end component;
    
    component coin_list is
        PORT(
            coin_sel : in std_logic_vector(1 downto 0);
            coin_amt : out std_logic_vector(11 downto 0)
        );
    end component;
    
    component deposit_register is
        Port ( 
                -- inputs
            clk      : in std_logic;
            rst      : in std_logic;
            incr     : in std_logic;
            incr_amt : in std_logic_vector(11 downto 0);
            decr     : in std_logic;
            decr_amt : in std_logic_vector(11 downto 0);
                --outputs
            amt      : out std_logic_vector(11 downto 0)
        );
    end component;
    
    component vending_machine_ctrl is
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
    end component;
    
    -- Soda List
    signal soda_list_price        : std_logic_vector(11 downto 0);
    signal soda_list_reserved     : std_logic;
    
    -- Coin List
    signal coin_list_amount       : std_logic_vector(11 downto 0);
    
    -- Deposit Register
    signal deposit_incr_flag      : std_logic;
    signal deposit_incr_amt       : std_logic_vector(11 downto 0);
    signal deposit_decr_flag      : std_logic;
    signal deposit_decr_amt       : std_logic_vector(11 downto 0);
    signal deposit_amt_signal     : std_logic_vector(11 downto 0) := X"000";
    
    -- Vending Machine Controller
    signal vend_soda_reserved     : std_logic;
    signal vend_soda_price        : std_logic_vector(11 downto 0);
    signal vend_deposit_amt       : std_logic_vector(11 downto 0);
    signal vend_coin_amt          : std_logic_vector(11 downto 0);
    signal vend_deposit_incr_flag : std_logic;
    signal vend_deposit_decr_flag : std_logic;

begin
    
    SODA_LIST_INST : soda_list
    PORT MAP(
        soda_price => soda_list_price,           -- Signal
        soda_sel => soda_sel,                    -- Top Level Subsystem
        soda_reserved => soda_list_reserved      -- Signal
    );

    COIN_LIST_INST : coin_list
    PORT MAP(
        coin_sel => coin_sel,                    -- Top Level Subsystem
        coin_amt => coin_list_amount             -- Signal
    );

    DEPOSIT_REG_INST : deposit_register
    PORT MAP(
        clk => clk,                              -- Top Level Subsystem
        rst => rst,                              -- Top Level Subsystem
        incr => deposit_incr_flag,               -- Signal
        incr_amt => deposit_incr_amt,            -- Signal
        decr => deposit_decr_flag,               -- Signal
        decr_amt => deposit_decr_amt,            -- Signal
        amt => deposit_amt_signal                -- Signal
    );

    VEND_CONTROL_INST : vending_machine_ctrl
    PORT MAP(
        clk => clk,                              -- Top Level Subsystem
        rst => rst,                              -- Top Level Subsystem
        lock => lock,                            -- Top Level Subsystem
        soda_reserved => vend_soda_reserved,     -- Signal
        soda_price => vend_soda_price,           -- Signal
        soda_req => soda_req,                    -- Top Level Subsystem
        deposit_amt => vend_deposit_amt,         -- Signal
        coin_push => coin_push,                  -- Top Level Subsystem
        coin_amt => vend_coin_amt,               -- Signal
        soda_drop => soda_drop,                  -- Top Level Subsystem
        deposit_incr => vend_deposit_incr_flag,  -- Signal
        deposit_decr => vend_deposit_decr_flag,  -- Signal
        coin_reject => coin_reject,              -- Top Level Subsystem
        error_amt => error_amt,                  -- Top Level Subsystem
        error_reserved => error_reserved         -- Top Level Subsystem
    );
    
    vend_coin_amt <= coin_list_amount;            -- Send Coin List 'coin_amt' output to Vending Machine Controller 'coin_amt' input.
    deposit_incr_amt <= coin_list_amount;         -- Send Coin List 'coin_amt' output to Deposit Register 'incr_amt' input.
    deposit_decr_amt <= soda_list_price;          -- Send Soda List 'soda_price' output to Deposit Register 'decr_amt' input.
    vend_soda_price <= soda_list_price;           -- Send Soda List 'soda_price' output to Vending Machine Controller 'soda_price' input.
    soda_price <= soda_list_price;                -- Send Soda List 'soda_price' output to the Outer Vending Machine System.
    vend_soda_reserved <= soda_list_reserved;     -- Send Soda List 'soda_reserved' output to Vending Machine Controller 'soda_reserved' input.
    soda_reserved <= soda_list_reserved;          -- Send Soda List 'soda_reserved' output to the Outer Vending Machine System.
    deposit_incr_flag <= vend_deposit_incr_flag;  -- Send Vending Machine Controller 'deposit_incr' to Deposit Register 'incr' input.
    deposit_decr_flag <= vend_deposit_decr_flag;  -- Send Vending Machine Controller 'deposit_decr' to Deposit Register 'decr' input.
    vend_deposit_amt <= deposit_amt_signal;       -- Send Deposit Register 'amt' output to Vending Machine Controller 'deposit_amt' input.
    deposit_amt <= deposit_amt_signal;            -- Send Deposit Register 'amt' output to Outer Vending Machine System.

end Behavioral;
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
           X"05F" WHEN "0010", -- Soda 2 = $0.95
           X"07D" WHEN "0011", -- Soda 3 = $1.25
           X"087" WHEN "0100", -- Soda 4 = $1.35
           X"096" WHEN "0101", -- Soda 5 = $1.50
           X"0E1" WHEN "0110", -- Soda 6 = $2.25
           X"0FA" WHEN "0111", -- Soda 7 = $2.50
           X"12C" WHEN "1000", -- Soda 8 = $3.00
           X"000" WHEN OTHERS; -- Soda Reserved
           
    -- soda_reserved <= '1' WHEN soda_sel > "1000" ELSE '0'; -- Set Soda Reserved Flag for Invalid Sodas.
    soda_reserved <= '1' WHEN unsigned(soda_sel) > 8 ELSE '0'; -- Set Soda Reserved Flag for Invalid Sodas.

end dataflow;


-- COIN LIST
library ieee;
use ieee.std_logic_1164.all;

entity coin_list is
    PORT(
        coin_sel : in std_logic_vector(1 downto 0);
        coin_amt : out std_logic_vector(11 downto 0)
    );
end coin_list;

architecture data_flow of coin_list is

begin
    
    WITH coin_sel SELECT coin_amt
        <= "000000000001" WHEN "00", -- Penny
           "000000000101" WHEN "01", -- Nickel
           "000000001010" WHEN "10", -- Dime
           "000000011001" WHEN "11", -- Quarter
           "000000000000" WHEN OTHERS;
     
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
    
    -- Add Architecture

begin

end Behavioral;


-- FINITE STATE MACHINE: when pushing a coin, coin is rejected if deposit amount > $10.00
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
    begin
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
    deposit_incr <= '1' WHEN (STATE = COIN_ACCEPT) ELSE '0';
    coin_reject <= '1' WHEN (STATE = COIN_DECLINE) ELSE '0';
    deposit_decr <= '1' WHEN (STATE = SODA_ACCEPT) ELSE '0';
    error_amt <= '1' WHEN (STATE = SODA_DECLINE_AMT) ELSE '0';
    soda_drop <= '1' WHEN (STATE = SODA_ACCEPT_WAIT) ELSE '0';
    error_reserved <= '1' WHEN (STATE = SODA_DECLINE_RESERVED) ELSE '0';

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
END entity;

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
    signal soda_price_signal     : std_logic_vector(11 downto 0);
    signal soda_select_signal    : std_logic_vector(3 downto 0);
    signal soda_reserved_signal  : std_logic;
    
    -- Coin List
    signal coin_select_signal    : std_logic_vector(1 downto 0);
    signal coin_amount_signal    : std_logic_vector(11 downto 0);

    -- Deposit Register
    signal depreg_clk_signal     : std_logic;
    signal depreg_rst_signal     : std_logic;
    signal incr_signal           : std_logic;
    signal incr_amt_signal       : std_logic_vector(11 downto 0);
    signal decr_signal           : std_logic;
    signal decr_amt_signal       : std_logic_vector(11 downto 0);
    signal amt_signal            : std_logic_vector(11 downto 0);

    -- Vending Machine Controller
    signal vend_clk_signal       : std_logic;
    signal vend_rst_signal       : std_logic;
    signal lock_signal           : std_logic;
    signal soda_reserved_signal  : std_logic;
    signal soda_price_signal     : std_logic_vector(11 downto 0);
    signal soda_req_signal       : std_logic;
    signal deposit_amt_signal    : std_logic_vector(11 downto 0);
    signal coin_push_signal      : std_logic;
    signal coin_amt_signal       : std_logic_vector(11 downto 0);
    signal soda_drop_signal      : std_logic;
    signal deposit_incr_signal   : std_logic;
    signal deposit_decr_signal   : std_logic;
    signal coin_reject_signal    : std_logic;
    signal error_amt_signal      : std_logic;
    signal error_reserved_signal : std_logic

begin

    SODA_LIST_INST : soda_list
    PORT MAP(
        soda_price => soda_price_signal,
        soda_sel => soda_select_signal,
        soda_reserved => soda_reserved_signal       
    );

    COIN_LIST_INST : coin_list
    PORT MAP(
        coin_sel => coin_select_signal;
        coin_amt => coin_amount_signal
    );

    DEPOSIT_REG_INST : deposit_register
    PORT MAP(
        clk => depreg_clk_signal;
        rst => depreg_rst_signal;
        incr => incr_signal;
        incr_amt => incr_amt_signal;
        decr => decr_signal;
        decr_amt => decr_amt_signal
        amt => amt_signal
    );

    VEND_CONTROL_INST : vending_machine_ctrl
    PORT MAP(
        clk => vend_clk_signal;
        rst => vend_rst_signal;
        lock => lock_signal;
        soda_reserved => soda_reserved_signal;
        soda_price => soda_price_signal;
        soda_req => soda_req_signal;
        deposit_amt => deposit_amt_signal;
        coin_push => coin_push_signal;
        coin_amt => coin_amt_signal;
        soda_drop => soda_drop_signal;
        deposit_incr => deposit_incr_signal;
        deposit_decr => deposit_decr_signal;
        coin_reject => coin_reject_signal;
        error_amt => error_amt_signal;
        error_reserved => error_reserved_signal;
    );

end Behavioral;
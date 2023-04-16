-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the wrapper for the Vending Machine Subsytem.

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
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the wrapper for the Vending Machine Subsystem.

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
    signal soda_price_list       : std_logic_vector(11 downto 0);
    signal soda_select_list      : std_logic_vector(3 downto 0);
    signal soda_reserved_list    : std_logic;
    
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
    signal soda_reserved_ctrl    : std_logic;
    signal soda_price_ctrl       : std_logic_vector(11 downto 0);
    signal soda_req_signal       : std_logic;
    signal deposit_amt_signal    : std_logic_vector(11 downto 0);
    signal coin_push_signal      : std_logic;
    signal coin_amt_signal       : std_logic_vector(11 downto 0);
    signal soda_drop_signal      : std_logic;
    signal deposit_incr_signal   : std_logic;
    signal deposit_decr_signal   : std_logic;
    signal coin_reject_signal    : std_logic;
    signal error_amt_signal      : std_logic;
    signal error_reserved_signal : std_logic;

begin

    SODA_LIST_INST : soda_list
    PORT MAP(
        soda_price => soda_price_list,
        soda_sel => soda_select_list,
        soda_reserved => soda_reserved_list
    );

    COIN_LIST_INST : coin_list
    PORT MAP(
        coin_sel => coin_select_signal,
        coin_amt => coin_amount_signal
    );

    DEPOSIT_REG_INST : deposit_register
    PORT MAP(
        clk => depreg_clk_signal,
        rst => depreg_rst_signal,
        incr => incr_signal,
        incr_amt => incr_amt_signal,
        decr => decr_signal,
        decr_amt => decr_amt_signal,
        amt => amt_signal
    );

    VEND_CONTROL_INST : vending_machine_ctrl
    PORT MAP(
        clk => vend_clk_signal,
        rst => vend_rst_signal,
        lock => lock_signal,
        soda_reserved => soda_reserved_ctrl,
        soda_price => soda_price_ctrl,
        soda_req => soda_req_signal,
        deposit_amt => deposit_amt_signal,
        coin_push => coin_push_signal,
        coin_amt => coin_amt_signal,
        soda_drop => soda_drop_signal,
        deposit_incr => deposit_incr_signal,
        deposit_decr => deposit_decr_signal,
        coin_reject => coin_reject_signal,
        error_amt => error_amt_signal,
        error_reserved => error_reserved_signal
    );

end Behavioral;
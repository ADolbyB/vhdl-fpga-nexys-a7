-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This File Implements the Main Vending Machine Controller System.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine_system is
    port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        soda_sel       : in  std_logic_vector(3 downto 0);
        soda_req       : in  std_logic;
        soda_drop      : out std_logic;
        cent_push      : in  std_logic;
        nickel_push    : in  std_logic;
        dime_push      : in  std_logic;
        quarter_push   : in  std_logic;
        coin_reject    : out std_logic;
        error_amt      : out std_logic;
        error_reserved : out std_logic;
        anode          : out std_logic_vector(7 downto 0);
        CA             : out std_logic;
        CB             : out std_logic;
        CC             : out std_logic;
        CD             : out std_logic;
        CE             : out std_logic;
        CF             : out std_logic;
        CG             : out std_logic;
        DP             : out std_logic 
    );
end vending_machine_system;

architecture structural of vending_machine_system is
    component vending_machine_cc is
        port (
            clk            : in  std_logic;
            rst_i          : in  std_logic;
            soda_sel_i     : in  std_logic_vector(3 downto 0);
            soda_req_i     : in  std_logic;
            cent_push_i    : in  std_logic;
            nickel_push_i  : in  std_logic;
            dime_push_i    : in  std_logic;
            quarter_push_i : in  std_logic;
    
            rst_o          : out std_logic;
            soda_sel_o     : out std_logic_vector(3 downto 0);
            soda_req_o     : out std_logic;
            cent_push_o    : out std_logic;
            nickel_push_o  : out std_logic;
            dime_push_o    : out std_logic;
            quarter_push_o : out std_logic 
        );
    end component;

    component vending_machine_input is
        port (
            clk            : in  std_logic;
    
            lock_i         : in  std_logic;
            soda_sel_i     : in  std_logic_vector(3 downto 0);
            soda_req_i     : in  std_logic;
            cent_push_i    : in  std_logic;
            nickel_push_i  : in  std_logic;
            dime_push_i    : in  std_logic;
            quarter_push_i : in  std_logic;
    
            lock_req_o     : out std_logic;
            soda_sel_o     : out std_logic_vector(3 downto 0);
            soda_req_o     : out std_logic;
            coin_push_o    : out std_logic;
            coin_sel_o     : out std_logic_vector(1 downto 0) 
        );
    end component;

    component locking_system is
        port (
            clk            : in  std_logic;
            rst            : in  std_logic;
            req_short_lock : in  std_logic;
            req_long_lock  : in  std_logic;
            lock           : out std_logic 
        );
    end component;

    component vending_machine_subsystem is
        port(
            clk             : in  std_logic;
            rst             : in  std_logic;
            lock            : in  std_logic;
            soda_sel        : in  std_logic_vector(3 downto 0);
            soda_req        : in  std_logic;
            coin_push       : in  std_logic;
            coin_sel        : in  std_logic_vector(1 downto 0);
            coin_reject     : out std_logic;
            soda_reserved   : out std_logic;
            soda_price      : out std_logic_vector(11 downto 0);
            soda_drop       : out std_logic;
            deposit_amt     : out std_logic_vector(11 downto 0);
            error_amt       : out std_logic;
            error_reserved  : out std_logic
        );
    end component;
    
    component vending_machine_led is
        port (
            clk                : in  std_logic;

            coin_reject_i      : in  std_logic;
            soda_drop_i        : in  std_logic;
            error_amt_i        : in  std_logic;
            error_reserved_i   : in  std_logic;

            lock_req_o         : out std_logic;
            coin_reject_o      : out std_logic;
            soda_drop_o        : out std_logic;
            error_amt_o        : out std_logic;
            error_reserved_o   : out std_logic 
        );
    end component;

    component vending_machine_7seg is
        port (
            clk                : in  std_logic;
            rst                : in  std_logic;

            soda_reserved_i    : in  std_logic;
            soda_price_i       : in  std_logic_vector(11 downto 0);
            deposit_amt_i      : in  std_logic_vector(11 downto 0);

            anode_o            : out std_logic_vector(7 downto 0);
            cathode_o          : out std_logic_vector(7 downto 0) 
        );
    end component;

    signal rst_cc             : std_logic;
    signal soda_sel_cc        : std_logic_vector(3 downto 0);
    signal soda_req_cc        : std_logic;
    signal cent_push_cc       : std_logic;
    signal nickel_push_cc     : std_logic;
    signal dime_push_cc       : std_logic;
    signal quarter_push_cc    : std_logic;

    signal soda_sel_s         : std_logic_vector(3 downto 0);
    signal soda_req_s         : std_logic;
    signal coin_push_s        : std_logic;
    signal coin_sel_s         : std_logic_vector(1 downto 0);
    
    signal req_short_lock_s   : std_logic;
    signal req_long_lock_s    : std_logic;
    signal lock_s             : std_logic;

    signal coin_reject_s      : std_logic;
    signal soda_drop_s        : std_logic;
    signal error_amt_s        : std_logic;
    signal error_reserved_s   : std_logic;
    
    signal soda_reserved_s    : std_logic;
    signal soda_price_s       : std_logic_vector(11 downto 0);
    signal deposit_amt_s      : std_logic_vector(11 downto 0);

    signal cathode_s          : std_logic_vector(7 downto 0);
begin

    u_vending_machine_cc: vending_machine_cc
    port map (
        clk            => clk             ,
        rst_i          => rst             ,
        soda_sel_i     => soda_sel        ,
        soda_req_i     => soda_req        ,
        cent_push_i    => cent_push       ,
        nickel_push_i  => nickel_push     ,
        dime_push_i    => dime_push       ,
        quarter_push_i => quarter_push    ,

        rst_o          => rst_cc          ,
        soda_sel_o     => soda_sel_cc     ,
        soda_req_o     => soda_req_cc     ,
        cent_push_o    => cent_push_cc    ,
        nickel_push_o  => nickel_push_cc  ,
        dime_push_o    => dime_push_cc    ,
        quarter_push_o => quarter_push_cc  
    );

    u_vending_machine_input: vending_machine_input
    port map (
        clk             => clk             ,

        lock_i          => lock_s          ,
        soda_sel_i      => soda_sel_cc     ,
        soda_req_i      => soda_req_cc     ,
        cent_push_i     => cent_push_cc    ,
        nickel_push_i   => nickel_push_cc  ,
        dime_push_i     => dime_push_cc    ,
        quarter_push_i  => quarter_push_cc ,

        lock_req_o      => req_short_lock_s,
        soda_sel_o      => soda_sel_s      ,
        soda_req_o      => soda_req_s      ,
        coin_push_o     => coin_push_s     ,
        coin_sel_o      => coin_sel_s       
    );

    u_locking_system: locking_system
    port map (
        clk            => clk               ,
        rst            => rst_cc            ,
        req_short_lock => req_short_lock_s  ,
        req_long_lock  => req_long_lock_s   ,
        lock           => lock_s             
    );

    u_vending_machine_subsystem: vending_machine_subsystem
    port map (
        clk            => clk               ,
        rst            => rst_cc            ,
        lock           => lock_s            ,
        soda_sel       => soda_sel_s        ,
        soda_req       => soda_req_s        ,
        coin_push      => coin_push_s       ,
        coin_sel       => coin_sel_s        ,
        coin_reject    => coin_reject_s     ,
        soda_reserved  => soda_reserved_s   ,
        soda_price     => soda_price_s      ,
        soda_drop      => soda_drop_s       ,
        deposit_amt    => deposit_amt_s     ,
        error_amt      => error_amt_s       ,
        error_reserved => error_reserved_s   
    );

    u_vending_machine_led: vending_machine_led
    port map (
        clk               => clk               ,
        coin_reject_i     => coin_reject_s     ,
        soda_drop_i       => soda_drop_s       ,
        error_amt_i       => error_amt_s       ,
        error_reserved_i  => error_reserved_s  ,

        lock_req_o        => req_long_lock_s   ,
        coin_reject_o     => coin_reject       ,
        soda_drop_o       => soda_drop         ,
        error_amt_o       => error_amt         ,
        error_reserved_o  => error_reserved     
    );

    u_vending_machine_7seg: vending_machine_7seg
    port map (
        clk               => clk               ,
        rst               => rst_cc            ,
        soda_reserved_i   => soda_reserved_s   ,
        soda_price_i      => soda_price_s      ,
        deposit_amt_i     => deposit_amt_s     ,
        anode_o           => anode             ,
        cathode_o         => cathode_s          
    );

    CA <= cathode_s(7);
    CB <= cathode_s(6);
    CC <= cathode_s(5);
    CD <= cathode_s(4);
    CE <= cathode_s(3);
    CF <= cathode_s(2);
    CG <= cathode_s(1);
    DP <= cathode_s(0);

end structural;
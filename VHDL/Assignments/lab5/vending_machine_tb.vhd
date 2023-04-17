-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Test Bench for the Vending Machine.
-- This tests all functionality and will produce an output in the TCL console if any component fails.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vending_machine_subsystem_tb is
    -- No entities in Test Benches
end vending_machine_subsystem_tb;

architecture behavioral of vending_machine_subsystem_tb is
    constant PERIOD : time := 1 ns;
    
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

    signal clk             : std_logic;
    signal rst             : std_logic;
    signal lock            : std_logic;
    signal soda_sel        : std_logic_vector(3 downto 0);
    signal soda_req        : std_logic;
    signal coin_push       : std_logic;
    signal coin_sel        : std_logic_vector(1 downto 0);
    signal coin_reject     : std_logic;
    signal soda_reserved   : std_logic;
    signal soda_price      : std_logic_vector(11 downto 0);
    signal soda_drop       : std_logic;
    signal deposit_amt     : std_logic_vector(11 downto 0);
    signal error_amt       : std_logic;
    signal error_reserved  : std_logic;

    signal sim_done        : std_logic;

    type t_soda_prices is array(0 to 15) of std_logic_vector(11 downto 0);
    constant soda_prices : t_soda_prices := (
        0      => conv_std_logic_vector(55 , 12),
        1      => conv_std_logic_vector(85 , 12),
        2      => conv_std_logic_vector(95 , 12),
        3      => conv_std_logic_vector(125, 12),
        4      => conv_std_logic_vector(135, 12),
        5      => conv_std_logic_vector(150, 12),
        6      => conv_std_logic_vector(225, 12),
        7      => conv_std_logic_vector(250, 12),
        8      => conv_std_logic_vector(300, 12),
        others => conv_std_logic_vector(0  , 12) 
    );

begin
    uut : vending_machine_subsystem 
    port map (
        clk            => clk             ,
        rst            => rst             ,
        lock           => lock            ,
        soda_sel       => soda_sel        ,
        soda_req       => soda_req        ,
        coin_push      => coin_push       ,
        coin_sel       => coin_sel        ,
        coin_reject    => coin_reject     ,
        soda_reserved  => soda_reserved   ,
        soda_price     => soda_price      ,
        soda_drop      => soda_drop       ,
        deposit_amt    => deposit_amt     ,
        error_amt      => error_amt       ,
        error_reserved => error_reserved   
    );

    gen_clk: process
    begin
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
        if sim_done = '1' then
            wait;
        end if;
    end process;

    tb: process
        variable v_error : std_logic;
    begin
        sim_done <= '0';
        v_error := '0';

        -- Initial values
        lock      <= '1';
        soda_sel  <= "0000";
        soda_req  <= '0';
        coin_push <= '0';
        coin_sel  <= "00";

--###################################
-- Test reset
--###################################
        -- Test reset
        rst <= '0';
        wait for PERIOD;
        rst <= '1';

        assert coin_reject = '0'
            report "Test Reset... failed: Coin reject not 0 after reset"
                severity failure;

        assert soda_drop = '0'
                report "Test Reset... failed: Soda drop not 0 after reset"
                    severity failure;

        assert deposit_amt = conv_std_logic_vector(0  , 12)
            report "Test Reset... failed: Deposit amount not $0.00 after reset"
                severity failure;

        assert error_amt = '0'
            report "Test Reset... failed: Error amount not 0 after reset"
                severity failure;

        assert error_reserved = '0'
            report "Test Reset... failed: Error reserved not 0 after reset"
                severity failure;

        wait for PERIOD;

--###################################
-- Soda price
--###################################
    rst <= '0';
    wait for 100*PERIOD;
    rst <= '1';

    for i in 0 to 8 loop
        soda_sel <= conv_std_logic_vector(i,4);
        wait for PERIOD;
        if soda_price /= soda_prices(i) then
            v_error := '1';
            report "Test soda " & integer'image(i) & " ... Failed: Soda price is not correct"
                severity error;
        end if;
        if soda_reserved /= '0' then
            v_error := '1';
            report "Test soda " & integer'image(i) & " ... Failed: soda should not be reserved"
                severity error;
        end if;
    end loop;

    for i in 9 to 15 loop
        soda_sel <= conv_std_logic_vector(i,4);
        wait for PERIOD;
        if soda_reserved /= '1' then
            v_error := '1';
            report "Test soda " & integer'image(i) & " ... Failed: soda should be reserved"
                severity error;
        end if;
    end loop;

    -- Test soda price failed
    if v_error = '1' then
        report "Testing soda price... Failed"
            severity failure;
    end if;
    soda_sel <= "0000";

--###################################
-- Test pushing coin
--###################################
        rst <= '0';
        wait for 100*PERIOD;
        rst <= '1';

        -- Test push cent
        rst <= '0';
        wait for PERIOD;
        rst <= '1';
        coin_push <= '1';
        coin_sel  <= "00";
        wait for PERIOD;
        coin_push <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        if deposit_amt /= conv_std_logic_vector(1, 12) then
            v_error := '1';
            report "Test push cent... Failed: Deposit amount not $0.01 after adding cent to deposit $0.00"
                severity error;
        end if;

        -- Test push nickel
        rst <= '0';
        wait for PERIOD;
        rst <= '1';
        coin_push <= '1';
        coin_sel  <= "01";
        wait for PERIOD;
        coin_push <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        if deposit_amt /= conv_std_logic_vector(5, 12) then
            v_error := '1';
            report "Test push nickel... Failed: Deposit amount not $0.05 after adding nickel to deposit $0.00"
                severity error;
        end if;

        -- Test push dime
        rst <= '0';
        wait for PERIOD;
        rst <= '1';
        coin_push <= '1';
        coin_sel  <= "10";
        wait for PERIOD;
        coin_push <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        if deposit_amt /= conv_std_logic_vector(10, 12) then
            v_error := '1';
            report "Test push dime... Failed: Deposit amount not $0.10 after adding dime to deposit $0.00"
                severity error;
        end if;

        -- Test push quarter
        rst <= '0';
        wait for PERIOD;
        rst <= '1';
        coin_push <= '1';
        coin_sel  <= "11";
        wait for PERIOD;
        coin_push <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        if deposit_amt /= conv_std_logic_vector(25, 12) then
            v_error := '1';
            report "Test push quarter... Failed: Deposit amount not $0.25 after adding quarter to deposit $0.00"
                severity error;
        end if;

        -- Test coin reject
        rst <= '0';
        wait for PERIOD;
        rst <= '1';

        -- Push $9.75
        coin_sel  <= "11";
        for i in 1 to 39 loop
            coin_push <= '1';
            wait for PERIOD;
            coin_push <= '0';
            lock <= '1';
            wait for 5*PERIOD;
            lock <= '0';
        end loop;

        -- Push $0.01
        coin_push <= '1';
        coin_sel  <= "00";
        wait for PERIOD;
        coin_push <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        if deposit_amt /= conv_std_logic_vector(976, 12) or coin_reject /= '0' then
            v_error := '1';
            report "Test push coins... Failed: Deposit amount not $9.76 after adding 39 quarters and 1 cent to deposit $0.00"
                severity error;
        end if;

        -- Push $0.25
        coin_push <= '1';
        coin_sel  <= "11";
        wait for PERIOD;
        coin_push <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        if deposit_amt /= conv_std_logic_vector(976, 12) or coin_reject /= '1' then
            v_error := '1';
            report "Test coin reject... Failed: Coin not rejected when adding a quarter to $9.76"
                severity error;
        end if;
        lock <= '0';
        wait for PERIOD;
        if deposit_amt /= conv_std_logic_vector(976, 12) or coin_reject /= '0' then
            v_error := '1';
            report "Test coin reject lock... Failed: Coin still rejected after lock is released"
                severity error;
        end if;

        -- Test pushing coins finish
        if v_error = '1' then
            report "Testing pushing coins... Failed"
                severity failure;
        end if;
        coin_sel <= "00";

--###################################
-- Test soda request
--###################################
        rst <= '0';
        wait for 100*PERIOD;
        rst <= '1';
        
        -- Pushing $8.00
        coin_sel <= "11";
        for i in 1 to 32 loop
            coin_push <= '1';
            wait for PERIOD;
            coin_push <= '0';
            lock <= '1';
            wait for 5*PERIOD;
            lock <= '0';
        end loop;

        -- Test buy soda 0 (accept)
        soda_sel  <= "0000";
        soda_req  <= '1';
        wait for PERIOD;
        soda_req  <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        if soda_drop /= '1' then
            v_error := '1';
            report "Test buy soda 0... Failed: Soda not dropped"
            severity failure;
        end if;
        if error_amt /= '0' then
            v_error := '1';
            report "Test buy soda 0... Failed: Error amount not 0"
            severity failure;
        end if;
        if error_reserved /= '0' then
            v_error := '1';
            report "Test buy soda 0... Failed: Error reserved not 0"
            severity failure;
        end if;
        lock <= '0';
        wait for PERIOD;
        if soda_drop /= '0' then
            v_error := '1';
            report "Test buy soda 0... Failed: Soda still dropping after lock is released"
            severity failure;
        end if;
        if deposit_amt /= conv_std_logic_vector(745, 12) then
            v_error := '1';
            report "Test buy soda 0... Failed: Deposit amount didn't decrease from $8.00 to $7.45"
            severity failure;
        end if;

        -- Test buy soda 3 (accept)
        soda_sel  <= "0011";
        soda_req  <= '1';
        wait for PERIOD;
        soda_req  <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        wait for PERIOD;
        if deposit_amt /= conv_std_logic_vector(620, 12) then
            v_error := '1';
            report "Test buy soda 3... Failed: Deposit amount didn't decrease from $7.45 to $6.20"
            severity failure;
        end if;

        -- Test buy soda 7 (accept)
        soda_sel  <= "0111";
        soda_req  <= '1';
        wait for PERIOD;
        soda_req  <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        wait for PERIOD;
        if deposit_amt /= conv_std_logic_vector(370, 12) then
            v_error := '1';
            report "Test buy soda 7... Failed: Deposit amount didn't decrease from $6.20 to $3.70"
            severity failure;
        end if;
        
        -- Test buy soda 8 (accept)
        soda_sel  <= "1000";
        soda_req  <= '1';
        wait for PERIOD;
        soda_req  <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        lock <= '0';
        wait for PERIOD;
        if deposit_amt /= conv_std_logic_vector(70, 12) then
            v_error := '1';
            report "Test buy soda 8... Failed: Deposit amount didn't decrease from $3.70 to $0.70"
            severity failure;
        end if;

        -- Test buy soda 1 (error amount)
        soda_sel  <= "0001";
        soda_req  <= '1';
        wait for PERIOD;
        soda_req  <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        if soda_drop /= '0' then
            v_error := '1';
            report "Test error amount... Failed: Soda dropped"
            severity failure;
        end if;
        if error_amt /= '1' then
            v_error := '1';
            report "Test error amount... Failed: Error amount not 1"
            severity failure;
        end if;
        if error_reserved /= '0' then
            v_error := '1';
            report "Test error amount... Failed: Error reserved not 0"
            severity failure;
        end if;
        lock <= '0';
        wait for PERIOD;
        if error_amt /= '0' then
            v_error := '1';
            report "Test error amount... Failed: Error amount still 1 after lock is released"
            severity failure;
        end if;
        if deposit_amt /= conv_std_logic_vector(70, 12) then
            v_error := '1';
            report "Test error amount... Failed: Deposit amount changed"
            severity failure;
        end if;

        -- Test buy soda 11 (error reserved)
        soda_sel  <= "1011";
        soda_req  <= '1';
        wait for PERIOD;
        soda_req  <= '0';
        lock <= '1';
        wait for 5*PERIOD;
        if soda_drop /= '0' then
            v_error := '1';
            report "Test error reserved... Failed: Soda dropped"
            severity failure;
        end if;
        if error_amt /= '0' then
            v_error := '1';
            report "Test error reserved... Failed: Error amount not 0"
            severity failure;
        end if;
        if error_reserved /= '1' then
            v_error := '1';
            report "Test error reserved... Failed: Error reserved not 1"
            severity failure;
        end if;
        lock <= '0';
        wait for PERIOD;
        if error_reserved /= '0' then
            v_error := '1';
            report "Test error reserved... Failed: Error reserved still 1 after lock is released"
            severity failure;
        end if;
        if deposit_amt /= conv_std_logic_vector(70, 12) then
            v_error := '1';
            report "Test error reserved... Failed: Deposit amount changed"
            severity failure;
        end if;

        -- Test soda coins finish
        if v_error = '1' then
            report "Testing soda request... Failed"
                severity failure;
        end if;

        coin_sel <= "00";
        soda_sel <= "0000";
--###################################
-- Test done
--###################################
        wait for 100*PERIOD;    

        report "Simulation passed!";
        sim_done <= '1';
        wait;
    end process;

end behavioral;
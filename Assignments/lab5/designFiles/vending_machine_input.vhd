-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file implements the functions of the user inputs.

library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_input is
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
end vending_machine_input;

architecture behavioral of vending_machine_input is
    signal button_lock_s       : std_logic;
    signal button_lock_pulse_s : std_logic;

    signal button_lock_r       : std_logic;
    signal lock_req_r          : std_logic;
    signal soda_sel_r          : std_logic_vector(3 downto 0);
    signal soda_req_r          : std_logic;
    signal coin_push_r         : std_logic;
    signal coin_sel_r          : std_logic_vector(1 downto 0);

    signal soda_sel_locked_r   : std_logic_vector(3 downto 0);
    signal soda_req_locked_r   : std_logic;
    signal coin_push_locked_r  : std_logic;
    signal coin_sel_locked_r   : std_logic_vector(1 downto 0);
begin
    button_lock_s <= soda_req_i or cent_push_i or nickel_push_i or dime_push_i or quarter_push_i;
    button_lock_pulse_s <= button_lock_s and not button_lock_r;

    INPUT_REG : process(clk)
    begin
        if rising_edge(clk) then
            button_lock_r <= button_lock_s;
            lock_req_r  <= button_lock_pulse_s;
            soda_sel_r  <= soda_sel_i;
            soda_req_r  <= soda_req_i;
            coin_push_r <= cent_push_i or nickel_push_i or dime_push_i or quarter_push_i;
            if cent_push_i = '1' then
                coin_sel_r <= "00";
            elsif nickel_push_i = '1' then
                coin_sel_r <= "01";
            elsif dime_push_i = '1' then
                coin_sel_r <= "10";
            else
                coin_sel_r <= "11";
            end if;
        end if;
    end process;

    PULSE_REG: process(clk)
    begin
        if rising_edge(clk) then
            if lock_req_r = '1' and lock_i = '0' then
                if coin_push_r = '1' then
                    coin_push_locked_r <= '1';
                    soda_req_locked_r  <= '0';
                elsif soda_req_r = '1' then
                    coin_push_locked_r <= '0';
                    soda_req_locked_r  <= '1';
                else
                    coin_push_locked_r <= '0';
                    soda_req_locked_r  <= '0';
                end if;
            else
                coin_push_locked_r <= '0';
                soda_req_locked_r  <= '0';
            end if;
        end if;
    end process;

    SEL_REG: process(clk)
    begin
        if rising_edge(clk) then
            if lock_i = '0' then
                soda_sel_locked_r <= soda_sel_r;
                coin_sel_locked_r <= coin_sel_r;
            end if;
        end if;
    end process;

    lock_req_o  <= lock_req_r         ;
    soda_sel_o  <= soda_sel_locked_r  ;
    soda_req_o  <= soda_req_locked_r  ;
    coin_push_o <= coin_push_locked_r ;
    coin_sel_o  <= coin_sel_locked_r  ;
    
end behavioral;
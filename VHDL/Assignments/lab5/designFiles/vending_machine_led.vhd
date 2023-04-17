-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file implements the output LED functions of the vending machine.

library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_led is
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
end vending_machine_led;

architecture behavioral of vending_machine_led is
    signal coin_reject_r       : std_logic;
    signal soda_drop_r         : std_logic;
    signal error_amt_r         : std_logic;
    signal error_reserved_r    : std_logic;

    signal led_lock_s          : std_logic;
    signal led_lock_pulse_s    : std_logic;

    signal led_lock_r          : std_logic;
    signal lock_req_r          : std_logic;
begin
    led_lock_s <= coin_reject_r or soda_drop_r or error_amt_r or error_reserved_r;
    led_lock_pulse_s <= led_lock_s and not led_lock_r;

    REG : process(clk)
    begin
        if rising_edge(clk) then
            coin_reject_r    <= coin_reject_i   ;
            soda_drop_r      <= soda_drop_i     ;
            error_amt_r      <= error_amt_i     ;
            error_reserved_r <= error_reserved_i;

            led_lock_r <= led_lock_s;
            lock_req_r <= led_lock_pulse_s;
        end if;
    end process;

    lock_req_o       <= lock_req_r       ;
    coin_reject_o    <= coin_reject_r    ;
    soda_drop_o      <= soda_drop_r      ;
    error_amt_o      <= error_amt_r      ;
    error_reserved_o <= error_reserved_r ;

end behavioral;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file defines the vending machine user input signals

library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_cc is
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
end vending_machine_cc;

architecture behavioral of vending_machine_cc is
    signal rst_r          : std_logic;
    signal soda_sel_r     : std_logic_vector(3 downto 0);
    signal soda_req_r     : std_logic;
    signal cent_push_r    : std_logic;
    signal nickel_push_r  : std_logic;
    signal dime_push_r    : std_logic;
    signal quarter_push_r : std_logic;
begin
    REG: process(clk)
    begin
        if rising_edge(clk) then
            rst_r          <= rst_i         ;
            soda_sel_r     <= soda_sel_i    ;
            soda_req_r     <= soda_req_i    ;
            cent_push_r    <= cent_push_i   ;
            nickel_push_r  <= nickel_push_i ;
            dime_push_r    <= dime_push_i   ;
            quarter_push_r <= quarter_push_i;

            rst_o          <= rst_r         ;
            soda_sel_o     <= soda_sel_r    ;
            soda_req_o     <= soda_req_r    ;
            cent_push_o    <= cent_push_r   ;
            nickel_push_o  <= nickel_push_r ;
            dime_push_o    <= dime_push_r   ;
            quarter_push_o <= quarter_push_r;
        end if;
    end process;
end behavioral;
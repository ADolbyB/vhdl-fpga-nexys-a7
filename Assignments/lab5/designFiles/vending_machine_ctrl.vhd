-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the FSM Finite State Machine of the Vending Machine
-- Note that when pushing a coin, the coin is rejected when the deposit amount
-- exceeds $10.00

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 12:36:31 AM
-- Design Name: 
-- Module Name: vending_machine_ctrl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Need Unsigned Only??

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

entity vending_machine_ctrl is
    Port ( 
        -- inputs
        clk             : in std_logic;
        rst             : in std_logic;
        lock            : in std_logic;
        soda_reserved   : in std_logic;
        soda_price      : in std_logic_vector(11 downto 0);
        soda_req        : in std_logic;
        deposit_amt     : in std_logic_vector(11 downto 0);
        coin_push       : in std_logic;
        coin_amt        : in std_logic_vector(11 downto 0);
        --outputs
        soda_drop       : out std_logic;
        deposit_incr    : out std_logic;
        deposit_decr    : out std_logic;
        coin_reject     : out std_logic;
        error_amt       : out std_logic;
        error_reserved  : out std_logic
        );
end vending_machine_ctrl;

architecture Behavioral of vending_machine_ctrl is
    


begin

end Behavioral;
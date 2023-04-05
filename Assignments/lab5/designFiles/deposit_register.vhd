-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Deposit Register for the Vending Machine
-- This Component accounts the amount deposited in cents.

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 12:36:31 AM
-- Design Name: 
-- Module Name: deposit_register - Behavioral
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

entity deposit_register is
    Port ( 
        -- inputs
        clk             : in std_logic;
        rst             : in std_logic;
        incr            : in std_logic;
        incr_amt        : in std_logic_vector(11 downto 0);
        decr            : in std_logic;
        decr_amt        : in std_logic_vector(11 downto 0);
        --outputs
        amt             : out std_logic_vector(11 downto 0)
    );
end deposit_register;

architecture Behavioral of deposit_register is
    


begin

end Behavioral;
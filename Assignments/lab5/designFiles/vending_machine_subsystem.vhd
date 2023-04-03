-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the wrapper for the Vending Machine.

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2023 12:36:31 AM
-- Design Name: 
-- Module Name: vending_machine_subsystem - Behavioral
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


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vending_machine_subsystem is
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
        deposit_amt     : out std_logic_vector(11 downto 0);
    );
end vending_machine_subsystem;

architecture Behavioral of vending_machine_subsystem is
    
    
    signal soda       : std_logic_vector(3 downto 0);   -- signal for user soda input
    signal coin_type  : std_logic_vector(2 downto 0);   -- signal for user coin type
    signal coin_value : std_logic_vector(4 downto 0);   -- 5 bits supports 0-31 values: $0.25
    signal soda_value : std_logic_vector(8 downto 0);   -- 9 bits supports 0-511 values: $3.00


begin


end Behavioral;

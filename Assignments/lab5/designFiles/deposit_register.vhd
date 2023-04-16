-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Deposit Register for the Vending Machine
-- This Component accounts the amount deposited in cents.

-- DEPOSIT REGISTER: accounts the amount deposited OR Decremented in cents.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity deposit_register is
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
end deposit_register;

architecture Behavioral of deposit_register is

    SIGNAL TOTAL_AMT : std_logic_vector(11 downto 0) := X"000"; -- Set inital Total Amt to $0.00
    
begin
    
    DEP_REG : PROCESS(rst, clk)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (rst = '0') THEN
                amt <= X"000";                                                            -- Reset deposit Credit
                TOTAL_AMT <= X"000";           
            ELSIF (incr = '1') THEN
                TOTAL_AMT <= std_logic_vector(unsigned(TOTAL_AMT) + unsigned(incr_amt));  -- Update Total Amount Intermediate Value
                amt <= std_logic_vector(unsigned(TOTAL_AMT) + unsigned(incr_amt));        -- Update Output Amount
            ELSIF (decr = '1') THEN
                TOTAL_AMT <= std_logic_vector(unsigned(TOTAL_AMT) - unsigned(decr_amt));  -- Update Total Amount Intermediate Value
                amt <= std_logic_vector(unsigned(TOTAL_AMT) - unsigned(decr_amt));        -- Update Output Amount
            END IF;
        END IF;       
    END PROCESS;

end Behavioral;
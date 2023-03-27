-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the wrapper file for the Carry-Save Multiplier

library ieee;
use ieee.std_logic_1164.all;

ENTITY mult is
    GENERIC(N : integer := 8);
    PORT(
        CLK : IN STD_LOGIC;
        A : IN std_logic_vector(N-1 downto 0);      -- 8 bit inputs
        B : IN std_logic_vector(N-1 downto 0);
        PROD : OUT std_logic_vector(2*N-1 downto 0) -- 16 bit output
    );
END mult;

architecture structural of mult is
    
    -- Add Component for Carry/Save Mult
    -- Don't need the Full Adder as a component

    -- Signals:
    SIGNAL A_Reg : std_logic_vector(N-1 downto 0);
    SIGNAL B_Reg : std_logic_vector(N-1 downto 0);
    SIGNAL PROD_Out : std_logic_vector(2*N-1 downto 0);

begin

    REG_Mult : process(clk);
    begin
        if rising_edge(clk) then
            -- on the rising edge, make the signals equal
            -- to the inputs and outputs carry_save_mult
        end if;
    end process;
end structural;

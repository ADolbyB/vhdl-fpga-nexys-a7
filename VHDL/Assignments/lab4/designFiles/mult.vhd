-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the wrapper file for the Carry-Save Multiplier

library ieee;
use ieee.std_logic_1164.all;

ENTITY mult is
    GENERIC(N : integer := 8);
    PORT(
        CLK : IN STD_LOGIC;
        A_mult : IN std_logic_vector(N-1 downto 0); -- 8 bit inputs
        B_mult : IN std_logic_vector(N-1 downto 0);
        PROD : OUT std_logic_vector(2*N-1 downto 0) -- 16 bit output
    );
END mult;

architecture structural of mult is

    -- we don't need the full_adder as component here
    -- add carry_save_mult as a component
    component carry_save_mult is
    GENERIC (N : integer := 8); -- N = Size of operands
        PORT(
            A : IN std_logic_vector(N-1 downto 0);
            B : IN std_logic_vector(N-1 downto 0);
            P : OUT std_logic_vector(2*N-1 downto 0) -- n bit * n bit = 2n bit result
        );
    end component;

    signal A_reg  : std_logic_vector(7 downto 0);
    signal B_reg  : std_logic_vector(7 downto 0);
    signal PROD_s : std_logic_vector(15 downto 0);
    
begin

    CSM : carry_save_mult -- instantiate carry_save_mult & create Port Map
        GENERIC MAP(N => N)
        PORT MAP(
            A => A_reg,
            B => B_reg,
            P => PROD_s
        );
    
    reg_mult : process(CLK)
    begin
        if rising_edge(CLK) then
            -- on the rising edge, make the signals equal
            -- to the inputs and outputs carry_save_mult
            A_reg <= A_mult;
            B_reg <= B_mult;
            PROD <= PROD_s;
            
        end if;
    end process;

end structural;
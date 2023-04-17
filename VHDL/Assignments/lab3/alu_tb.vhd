-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Test Bench for the ALU.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; -- CONV_STD_LOGIC_VECTOR Function

entity alu_tb is
    -- No Declarations inside Test Bench
end alu_tb;

architecture behavioral of alu_tb is
    component alu is
        generic(N : integer := 6);
        PORT(
            A, B : IN std_logic_vector(N-1 downto 0); -- 6 bit input signals
            SEL : IN std_logic_vector(3 downto 0);    -- 4 bit select
            R : OUT std_logic_vector(N-1 downto 0)    -- 6 bit output signal
        );
    
end component;
    
    CONSTANT N : integer := 6;
    CONSTANT CLK_PER : time := 10ns;
    
    SIGNAL A_tb : std_logic_vector(N-1 downto 0);
    SIGNAL B_tb : std_logic_vector(N-1 downto 0);
    SIGNAL SEL_tb : std_logic_vector(3 downto 0);
    SIGNAL R_tb : std_logic_vector(N-1 downto 0);

begin
    
    alu_inst : alu -- instantiate the alu component
    PORT MAP(
        A => A_tb,
        B => B_tb,
        SEL => SEL_tb,
        R => R_tb
    );
    
    test_bench : process -- instantiate test_bench process
    begin
    
        A_tb <= "000100"; -- 1st Case: A = 4, B = 2
        B_tb <= "000010";
        for i in 0 to 15 loop
            SEL_tb <= conv_std_logic_vector(i, 4);
            wait for CLK_PER;
        end loop;
    
        wait for 2 * CLK_PER;
    
        A_tb <= "110001"; -- 2nd Case: A = 49, B = 50
        B_tb <= "110010";
        for i in 0 to 15 loop
            SEL_tb <= conv_std_logic_vector(i, 4);
            wait for CLK_PER;
        end loop;
        
        wait for 2 * CLK_PER;
        
        A_tb <= "111111"; -- 3rd Case: A = 63, B = 63
        B_tb <= "111111";
        for i in 0 to 15 loop
            SEL_tb <= conv_std_logic_vector(i, 4);
            wait for CLK_PER;
        end loop;
        
        wait for 2 * CLK_PER;
    
    wait;
    end process; -- END Test Bench

end behavioral;
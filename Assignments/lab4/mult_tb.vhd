-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the Test Bench for the Carry-Save Multiplier

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity mult_tb is
    -- No Entities in Test Bench
end mult_tb;

-- after completing the design, write the simulation testbench.
-- make sure to add "create clock -period 10 -name clk [get ports clk]" to your constraints file.

architecture behavioral of mult_tb is

    -- ADD "mult8x8.dat" AS A SIMULATION SOURCE FIRST
    -- file variable to read data from
    file MULT_FILE : text OPEN READ_MODE is "mult8x8.dat";

    -- mult components
    component mult is
        GENERIC(N : integer := 8);
        PORT(
            CLK : IN STD_LOGIC;
            A : IN std_logic_vector(N-1 downto 0);      -- 8 bit inputs
            B : IN std_logic_vector(N-1 downto 0);
            PROD : OUT std_logic_vector(2*N-1 downto 0) -- 16 bit output
        );
    end component;
    
    CONSTANT N : integer := 8;
    CONSTANT CLK_PER : time := 10ns; -- create period constant(CLOCK?)
    
    signal CLK_tb : std_logic;
    signal A_tb : std_logic_vector(N-1 downto 0);
    signal B_tb : std_logic_vector(N-1 downto 0);
    signal PROD_tb : std_logic_vector(2*N-1 downto 0);
    
begin
    -- Instantiation Of Components
    multiplier : mult -- instantiate mult component
        PORT MAP (
            A => A_tb,
            B => B_tb,
            CLK => CLK_tb,
            PROD => PROD_tb
        );

    clk_gen: process -- generate the process for the clock similar to previous lab 0 and lab 2
        begin
            clk_tb <= '0';
            wait for CLK_PER;
            clk_tb <= '1';
            wait for CLK_PER;
        end process;
    
    test_bench : process -- Begin Test Bench Process:
        variable cur_line   : integer := 1; -- variables for reading for MULT_FILE
        variable v_line     : line;
        variable v_space    : character;
        variable v_a        : std_logic_vector(7 downto 0);
        variable v_b        : std_logic_vector(7 downto 0);
        variable v_p_exp    : std_logic_vector(15 downto 0);

    begin

        -- useful functions 
        -- while not endfile("FILE"): keeps reading until reaching the end of the file.
        -- readline("FILE","VARIABLE"): reads 1 line at a time from file and stores it in variable.
        -- hread("VARIABLE", "VARIABLE"): reads from the 1st variable into the 2nd variable in HEX format.
        -- read("VARIABLE", "VARIABLE"): reads from the 1st variable into the 2nd variable.

        -- you must replace "FILE" and "VARIABLE" with your file name and appropriate variable names.
        
        -- after reading the data into each variable, set your signals equal to the variables
        -- and wait for 2*PERIOD. Next, assert that your product is equal to the expected product,
        -- and then start reading from the next line. If all the products are correct, report that the
        -- simulation was complete.

        wait;
    
    end process;

end behavioral;
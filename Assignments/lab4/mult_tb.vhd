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
            A_mult : IN std_logic_vector(N-1 downto 0);     -- 8 bit inputs
            B_mult : IN std_logic_vector(N-1 downto 0);
            PROD : OUT std_logic_vector(2*N-1 downto 0)     -- 16 bit output
        );
    end component;
    
    CONSTANT N : integer := 8;
    CONSTANT CLK_PER : time := 10ns;
    
    signal CLK_tb : std_logic;
    signal A_tb : std_logic_vector(N-1 downto 0);
    signal B_tb : std_logic_vector(N-1 downto 0);
    signal PROD_tb : std_logic_vector(2*N-1 downto 0);
    
begin
    -- Instantiation Of Components
    CLK_gen: process -- generate the process for the clock similar to previous lab 0 and lab 2
        begin
            CLK_tb <= '0';
            wait for CLK_PER / 2;
            CLK_tb <= '1';
            wait for CLK_PER / 2;
        end process;
    
    multiplier : mult -- instantiate mult component
        GENERIC MAP(N => N)
        PORT MAP (
            A_mult => A_tb,
            B_mult => B_tb,
            CLK => CLK_tb,
            PROD => PROD_tb
        );

    test_bench : process                        -- Begin Test Bench Process:
        variable current_line : integer := 1;   -- variables for reading MULT_FILE
        variable v_line       : line;
        variable v_space      : character;
        variable v_a          : std_logic_vector(7 downto 0);
        variable v_b          : std_logic_vector(7 downto 0);
        variable v_prod_exp   : std_logic_vector(15 downto 0);

    begin

        WHILE NOT endfile(MULT_FILE) LOOP   -- keeps reading until reaching the end of the file.
            READLINE(MULT_FILE, v_line);    -- reads 1 line at a time from file and stores it in variable.
            HREAD(v_line, v_a);             -- reads from the 1st variable into the 2nd variable in HEX format.
            READ(v_line, v_space);          -- reads from the 1st variable into the 2nd variable.
            HREAD(v_line, v_b);
            READ(v_line, v_space);
            HREAD(v_line, v_prod_exp);
            A_tb <= v_a;                    -- after reading the data into each variable, set your signals equal to the variables
            B_tb <= v_b;
            wait for 2 * CLK_PER;

            ASSERT PROD_tb = v_prod_exp
                REPORT "Actual Result Not Matching Expected Result At Line #" & integer'image(current_line)
                    severity failure;

            current_line := current_line + 1;
        end loop;

        REPORT "SIMULATION SUCCESS!!";      -- If all the products are correct, report that the simulation was successful.
        wait;

    end process;

end behavioral;
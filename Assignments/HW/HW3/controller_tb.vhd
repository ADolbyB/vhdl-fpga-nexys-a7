-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Test Bench for Finite State Machine

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity controller_tb is
    -- No entity in Test Bench
end entity;

architecture behavioral of controller_tb is

    component controller IS
    PORT( 
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        X : OUT STD_LOGIC;
        Y : OUT STD_LOGIC;
        Z : OUT STD_LOGIC
    );
    END component;

    -- Define Signals and Constants
    constant CLK_PER : time := 100ns;
    signal CLK_tb : STD_LOGIC;
    signal RST_tb : STD_LOGIC;
    signal A_tb : STD_LOGIC;
    signal B_tb : STD_LOGIC;
    signal X_tb : STD_LOGIC;
    signal Y_tb : STD_LOGIC;
    signal Z_tb : STD_LOGIC:

begin

    -- Instantiation Of Components
    controller_inst : controller
    port map(
        CLK => CLK_tb,
        RST => RST_tb,
        A => A_tb,
        B => B_tb,
        X => X_tb,
        Y => Y_tb,
        Z => Z_tb
    );

    CLK_gen : process
    begin
        CLK_tb <= '0';
        wait for CLK_PER / 2;
        CLK_tb <= '1';
        wait for CLK_PER / 2;
    end process;

    test_bench : process
    begin
        -- Initial Values According to Timing Diagram
        RST_tb <= '1';
        A_tb <= '1';
        B_tb <= '1';

        wait for CLK_PER / 4; -- wait for 25ns (total time = 25ns)
        A_tb <= '0';

        wait for CLK_PER / 4; -- wait for 25ns (total time = 50ns)
        RST_tb <= '0';
        B_tb <= '0';

        wait for CLK_PER / 4; -- wait for 25ns (total time = 75ns)
        A_tb <= '1';

        wait for 75ns; -- total time = 150ns
        B_tb <= '1';

        wait for CLK_PER / 4; -- total time = 175ns
        A_tb <='0';

        wait for CLK_PER / 2; -- total time = 225ns
        A_tb <= '1';
        B_tb <= '0';

        wait for CLK_PER / 2; -- total time = 275ns
        B_tb <= '1';

        wait for CLK_PER / 2: -- total time = 325ns
        A_tb <= '0';

        wait for CLK_PER / 4; -- total time = 350ns
        B_tb <= '0';

        wait for CLK_PER / 4; -- total time = 375ns
        A_tb <= '1';

        wait for 75ns; -- total time = 450ns
        B_tb <= '1';

        wait for CLK_PER / 4; -- total time = 475ns
        A_tb <= '0';
        
        wait for 35ns; -- total time = 510ns
        B_tb <= '0';

        wait for 15ns; -- total time = 525ns
        A_tb <= '1';

        wait for 75ns; -- total time = 600ns

        wait;
    end process;

end behavioral;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the test bench for simulation.

library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;

-- Entity Declaration
entity comparator_tb is
    -- NO inputs and outputs in test benches!!
end comparator_tb;

architecture behavioral of comparator_tb is
    -- Component Declaration
    component comparator_top 
        port(
            X, Y : in std_logic_vector (1 downto 0);
            Z : out std_logic_vector (3 downto 0)
            );
end component ;

-- Signals are used instead of inputs and outputs
signal X_in , Y_in : std_logic_vector (1 downto 0);
signal Z_out : std_logic_vector (3 downto 0);

begin
    -- Component Instantiation
    uut: comparator_top
    port map (
            X => X_in,
            Y => Y_in,
            Z => Z_out
            );
-- Test Bench Statements
    tb : process
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                X_in <= conv_std_logic_vector (i, 2);
                Y_in <= conv_std_logic_vector (j, 2);
                wait for 100 ns;
            end loop;
        end loop;
        wait;
    end process;
end behavioral;
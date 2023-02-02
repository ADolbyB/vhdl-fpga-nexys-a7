-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the test bench for simulation.

library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration
entity mydesign1 is
    port(
        clk  : in  std_logic;
        din  : in  std_logic_vector(1 downto 0);
        dout : out std_logic_vector(1 downto 0)
        );
end mydesign1;

-- Behavioral architecture
architecture behavioral of mydesign1 is
    -- Intermediate signals
    signal data_r : std_logic_vector(1 downto 0);
begin

    -- Instantiation
    REG :process(clk)
    begin
        if rising_edge(clk) then
            data_r <= din;
            dout <= data_r;
        end if;
    end process;

end behavioral;
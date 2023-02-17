-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Flip Flop / Registers for storing data.

library ieee;
use ieee.std_logic_1164.all;

entity reg_module is
    generic(n : integer := 4);
    port(
        clk : in std_logic;
        rst : in std_logic;
        we : in std_logic;
        din : in std_logic_vector (n-1 downto 0);
        dout : out std_logic_vector (n-1 downto 0)
    );
end reg_module;

architecture behavioral of reg_module is

begin
    -- N bit register w/ enable (always syncronous)
    -- N bit register with ASYNC ACTIVE LOW Reset
    process (clk, rst) -- Async Reset
    begin
        if rst = '0' then
            dout <= (OTHERS => '0'); -- Set all N bits to 0
        elsif rising_edge(clk) then
            if we = '1' then
                dout <= din;
            end if;
        end if;
    end process;

end behavioral;
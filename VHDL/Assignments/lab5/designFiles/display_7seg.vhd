-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file implements the 7 segment display on the Artix-7

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_7seg is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        digit0  : in  std_logic_vector(7 downto 0);
        digit1  : in  std_logic_vector(7 downto 0);
        digit2  : in  std_logic_vector(7 downto 0);
        digit3  : in  std_logic_vector(7 downto 0);
        digit4  : in  std_logic_vector(7 downto 0);
        digit5  : in  std_logic_vector(7 downto 0);
        digit6  : in  std_logic_vector(7 downto 0);
        digit7  : in  std_logic_vector(7 downto 0);
        anode   : out std_logic_vector(7 downto 0);
        cathode : out std_logic_vector(7 downto 0) 
    );
end display_7seg;

architecture behavioral of display_7seg is
    -- FREQ = 100 MHz
    -- REFRESH RATE = (counter)/FREQ = (2^19)/100,000 = 5.24ms
    constant COUNTER_SZ : integer := 19;
    signal counter : std_logic_vector(COUNTER_SZ-1 downto 0);
begin

    cathode_anode: process(clk)
    begin
        if rising_edge(clk) then
            case counter(COUNTER_SZ-1 downto COUNTER_SZ-3) is
                when "000" =>
                    anode   <= "11111110";
                    cathode <= digit0;
                when "001" =>
                    anode   <= "11111101";
                    cathode <= digit1;
                when "010" =>
                    anode   <= "11111011";
                    cathode <= digit2;
                when "011" =>
                    anode   <= "11110111";
                    cathode <= digit3;
                when "100" =>
                    anode   <= "11101111";
                    cathode <= digit4;
                when "101" =>
                    anode   <= "11011111";
                    cathode <= digit5;
                when "110" =>
                    anode   <= "10111111";
                    cathode <= digit6;
                when "111" =>
                    anode   <= "01111111";
                    cathode <= digit7;
                when others =>
                    anode   <= (others => '1');
                    cathode <= (others => '1');
            end case;
        end if;
    end process;

    COUNTER_REG: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                counter <= (others => '0');
            else
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end process;

end behavioral;
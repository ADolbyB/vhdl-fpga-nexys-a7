-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- 8 to 1 MUX for reading output of registers

library ieee;
use ieee.std_logic_1164.all;

entity mux_8to1 is
    generic(n : integer := 4); -- each input is 'n' bits wide
    port(
        sel : in std_logic_vector (2 downto 0); -- 3 bit select / 8 addresses
        din0 : in std_logic_vector (n-1 downto 0);
        din1 : in std_logic_vector (n-1 downto 0);
        din2 : in std_logic_vector (n-1 downto 0);
        din3 : in std_logic_vector (n-1 downto 0);
        din4 : in std_logic_vector (n-1 downto 0);
        din5 : in std_logic_vector (n-1 downto 0);
        din6 : in std_logic_vector (n-1 downto 0);
        din7 : in std_logic_vector (n-1 downto 0);
        dout : out std_logic_vector (n-1 downto 0)
    );
end mux_8to1;

architecture dataflow of mux_8to1 is
begin
    with sel select
        dout <= din0 WHEN "000",
                din1 WHEN "001",
                din2 WHEN "010",
                din3 WHEN "011",
                din4 WHEN "100",
                din5 WHEN "101",
                din6 WHEN "110",
                din7 WHEN OTHERS;

end dataflow;
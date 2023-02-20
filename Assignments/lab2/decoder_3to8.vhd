-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- 3 to 8 decoder for addressing register inputs

library ieee;
use ieee.std_logic_1164.all;

entity decoder_3to8 is
    PORT(
        en : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bit bus w in
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- 8 bit bus y out
    );
end entity decoder_3to8;

architecture dataflow OF decoder_3to8 IS
    SIGNAL enDin : STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
    enDin <= en & din; -- MSB = en, LSB = din
    WITH enDin SELECT
        dout <= "00000001" WHEN "1000", -- MSB is the ENABLE bit
                "00000010" WHEN "1001",
                "00000100" WHEN "1010",
                "00001000" WHEN "1011",
                "00010000" WHEN "1100",
                "00100000" WHEN "1101",
                "01000000" WHEN "1110",
                "10000000" WHEN "1111",
                "00000000" WHEN OTHERS;
end dataflow;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This file implements the binary coded decimal decoder for the 7 segment display.

library ieee;
use ieee.std_logic_1164.all;

entity decoder_bcd_7seg is
    port (
        invalid : in  std_logic;
        din     : in  std_logic_vector(3 downto 0);
        dout    : out std_logic_vector(6 downto 0)
    );
end decoder_bcd_7seg;

architecture behavioral of decoder_bcd_7seg is
begin
    DECODE: process(invalid, din)
    begin
        if invalid = '1' then
            dout <= "1111110"; -- invalid
        else
            case(din) is
                when "0000" => dout <= "0000001"; --0
                when "0001" => dout <= "1001111"; --1
                when "0010" => dout <= "0010010"; --2
                when "0011" => dout <= "0000110"; --3
                when "0100" => dout <= "1001100"; --4
                when "0101" => dout <= "0100100"; --5
                when "0110" => dout <= "0100000"; --6
                when "0111" => dout <= "0001111"; --7
                when "1000" => dout <= "0000000"; --8
                when "1001" => dout <= "0000100"; --9
                when others => dout <= "1111110"; --invalid
            end case;
        end if;
    end process;
end behavioral;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Practice Exam QA
-- This is a 2to4 Decoder with Enable.
-- This is a DATAFLOW example.

library IEEE;
USE IEEE.std_logic_1164.all;

entity QA is
    PORT(
        W : in std_logic_vector(1 downto 0);
        EN : in std_logic;
        Y : out std_logic_vector(3 downto 0);
    );
end QA;

architecture dataflow of QA is
    SIGNAL ENW : std_logic_vector(2 downto 0);
begin
    ENW <= EN & W;
    with ENW select
        Y <= "0001" when "100",
             "0010" when "101",
             "0100" when "110",
             "1000" when "111",
             "0000" when OTHERS;
end dataflow;
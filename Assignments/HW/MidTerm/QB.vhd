-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Practice Exam QA
-- This is a Priority Encoder with the MSB input having highest priority.
-- This is a DATAFLOW example.

library IEEE;
USE IEEE.std_logic_1164.all;

entity QB is
    PORT(
        W : in std_logic_vector(3 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic;
    );
end QB;

architecture dataflow of QB is

begin
    Y <= "11" when W(3) = '1' else
         "10" when W(2) = '1' else
         "01" when W(1) = '1' else
         "00";
    Z <= '0' WHEN W = "0000" else '1';
end dataflow;
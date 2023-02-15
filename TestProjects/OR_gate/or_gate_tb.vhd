-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Test Bench / Simulation Program for OR gate

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity or_gate_tb is
end;

architecture bench of or_gate_tb is

  component or_gate
      Port (
          a : in std_logic;
          b : in std_logic;
          c : out std_logic
      );
  end component;

  signal a: std_logic;
  signal b: std_logic;
  signal c: std_logic;

begin

  uut : or_gate 
    port map ( 
      a => a,
      b => b,
      c => c
    );
  stimulus: process
  begin
    a <= '0';
    b <= '0';
    wait for 10 ns;
    a <= '0';
    b <= '1';
    wait for 10 ns;
    a <= '1';
    b <= '0';
    wait for 10 ns;
    a <= '1';
    b <= '1';
    wait for 10 ns;
    wait;
  end process;

end;
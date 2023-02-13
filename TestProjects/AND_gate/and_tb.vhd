-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Test Bench / Simulation file to test an AND gate

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity and_gate_tb is
end;

architecture bench of and_gate_tb is

  component and_gate
      Port (
          a : in std_logic;
          b : in std_logic;
          c : out std_logic
      );
  end component;

  signal a: std_logic;
  signal b: std_logic;
  signal c: std_logic ;

begin

  uut : and_gate 
    port map ( 
      a => a,
      b => b,
      c => c
    );
  stimulus: process
  begin
    -- Initialization code here
    a <= '0';
    b <= '0';
    wait for 10ns;
    a <= '0';
    b <= '1';
    wait for 10ns;
    a <= '1';
    b <= '0';
    wait for 10ns;
    a <= '1';
    b <= '1';
    wait for 10ns;
    wait;
  end process;

end;
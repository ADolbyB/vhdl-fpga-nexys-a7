library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity StartStopRun_tb is
end;

architecture behavioral of StartStopRun_tb is

  constant CLK_PERIOD : time := 20 ns;

  component Start_Stop_Run
      Port(
          CLOCK : in std_logic;
          START : in std_logic;
          STOP : in std_logic;
          RUN : out std_logic
      );
  end component;

  -- Component Signals
  signal CLOCK : std_logic;
  signal START : std_logic;
  signal STOP : std_logic;
  signal RUN : std_logic;

begin

  uut: Start_Stop_Run
    port map ( 
        CLOCK => CLOCK,
        START => START,
        STOP => STOP,
        RUN => RUN 
        );

  clk_gen : process
  begin
    CLOCK <= '0';
    wait for CLK_PERIOD / 2;
    CLOCK <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  tb : process
  begin
  
    START <= '0';
    STOP <= '0';
    wait for 35 ns;
    START <= '1';
    STOP <= '0';
    wait for 35 ns;
    START <= '0';
    STOP <= '0';
    wait for 35 ns;
    START <= '0';
    STOP <= '1';
    wait for 35 ns;
    START <= '0';
    STOP <= '0';
    wait for 35 ns;
    START <= '1';
    STOP <= '0';
    wait for 35 ns;
    START <= '0';
    STOP <= '1';
    wait for 35 ns;
    wait;
  end process;

end behavioral;
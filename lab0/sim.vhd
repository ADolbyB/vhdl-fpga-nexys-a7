library ieee;
use ieee.std_logic_1164.all;

entity mysim1 is
end mysim1;

architecture behavioral of mysim1 is
    -- period to wait for one clock cycle
    constant PERIOD : time := 10 ns;

    -- Component Declaration
    component mydesign1 is
        port(
            clk  : in  std_logic;
            din  : in  std_logic_vector(1 downto 0);
            dout : out std_logic_vector(1 downto 0)
        );
    end component;
    
    -- Signals for component
    signal clk  : std_logic;
    signal din  : std_logic_vector(1 downto 0);
    signal dout : std_logic_vector(1 downto 0);
    
begin

    -- Component instantiation
    UUT : mydesign1
    port map(
          clk  => clk,
          din  => din,
          dout => dout
    );
    
    -- Generate clock signal
    clk_gen: process
    begin
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
    end process;
    
    --  Test Bench Statements
    tb : process
    begin
        din <= "00";
        wait for 100 ns;
        din <= "01";
        wait for 100 ns;
        din <= "10";
        wait for 100 ns;
        din <= "11";
        wait;
    end process;

end behavioral;
-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Test Bench Program for Register Project

library ieee;
use ieee.std_logic_1164.all;

entity reg_file_tb is
    -- Nothing in entity
end reg_file_tb;

architecture behavioral of reg_file_tb is
    component reg_file is
        port(
            clk : in std_logic;
            rst : in std_logic;
            we : in std_logic;
            addr : in std_logic_vector(2 downto 0);
            din : in std_logic_vector(3 downto 0);
            dout : out std_logic_vector(3 downto 0)
        );
end component;

    constant PERIOD : time := 20 ns;
    
    signal clk_tb : std_logic;                    
    signal rst_tb : std_logic;                    
    signal we_tb : std_logic;                     
    signal addr_tb : std_logic_vector(2 downto 0);
    signal din_tb : std_logic_vector(3 downto 0); 
    signal dout_tb : std_logic_vector(3 downto 0);

begin
    -- Format:
    -- LABEL : COMPONENT
    -- PORT MAP (
    --  );
    reg_file_inst : reg_file
    
    PORT MAP (
        clk => clk_tb,
        rst => rst_tb,
        we => we_tb,
        addr => addr_tb,
        din => din_tb,
        dout => dout_tb
    );
    
    clk_gen : process
    begin
        clk_tb <= '0';
        wait for PERIOD / 2;
        clk_tb <= '1';
        wait for PERIOD / 2;
    end process;
    
    tb : process
    begin -- Can use FOR LOOP to make code more concise
        -- Test Write To Registers for Waveform

        we_tb <= '1';  -- Enable Writing
        rst_tb <= '0'; -- Reset all registers to 0000 before writing
        wait for 2 ns;
        rst_tb <= '1'; -- Disable RESET to prevent UNDEFINED value (Active Low)
        wait for 2 ns;
        
        addr_tb <= "000"; -- Write to Register 0
        din_tb <= "0111"; -- give it a random value
        wait for PERIOD;
        
        addr_tb <= "001"; -- Write to Register 1;
        din_tb <= "1101";
        wait for PERIOD;
        
        addr_tb <= "010"; -- Write to Register 2
        din_tb <= "1010";
        wait for PERIOD;
        
        addr_tb <= "011"; -- Write to Register 3
        din_tb <= "1110";
        wait for PERIOD;
        
        addr_tb <= "100"; -- Write to Register 4
        din_tb <= "0101";
        wait for PERIOD;
        
        addr_tb <= "101"; -- Write to Register 5
        din_tb <= "0110";
        wait for PERIOD;
        
        addr_tb <= "110"; -- Write to Register 6
        din_tb <= "1001";
        wait for PERIOD;
        
        addr_tb <= "111"; -- Write to Register 7
        din_tb <= "1101";
        wait for PERIOD;
        
        -- DONE Writing
        we_tb <= '0'; -- Switch to READ mode
        wait for PERIOD;
        
        -- Read the registers
        addr_tb <= "000"; -- Reg 0: DOUT = 0111
        wait for PERIOD;
        addr_tb <= "001"; -- Reg 1: DOUT = 1101
        wait for PERIOD;
        addr_tb <= "010"; -- Reg 2: DOUT = 1010
        wait for PERIOD;
        addr_tb <= "011"; -- Reg 3: DOUT = 1110
        wait for PERIOD;
        addr_tb <= "100"; -- Reg 4: DOUT = 0101
        wait for PERIOD;
        addr_tb <= "101"; -- Reg 5: DOUT = 0110
        wait for PERIOD;
        addr_tb <= "110"; -- Reg 6: DOUT = 1001
        wait for PERIOD;
        addr_tb <= "111"; -- Reg 7: DOUT = 1111
        wait for PERIOD;
        
        -- Reset all registers
        rst_tb <= '0';
        wait for 2 ns;
        rst_tb <= '1';
        
        -- Read registers again: should all be 0000
        addr_tb <= "000"; -- Reg 0: DOUT = 0000
        wait for PERIOD;
        addr_tb <= "001"; -- Reg 1: DOUT = 0000
        wait for PERIOD;
        addr_tb <= "010"; -- Reg 2: DOUT = 0000
        wait for PERIOD;
        addr_tb <= "011"; -- Reg 3: DOUT = 0000
        wait for PERIOD;
        addr_tb <= "100"; -- Reg 4: DOUT = 0000
        wait for PERIOD;
        addr_tb <= "101"; -- Reg 5: DOUT = 0000
        wait for PERIOD;
        addr_tb <= "110"; -- Reg 6: DOUT = 0000
        wait for PERIOD;
        addr_tb <= "111"; -- Reg 7: DOUT = 0000
        wait for PERIOD;
        
        wait; -- Stop Simulation (otherwise it will keep looping)

    end process;

end behavioral;
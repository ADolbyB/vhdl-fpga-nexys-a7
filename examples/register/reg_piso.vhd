-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an example of an Parallel In Serial Out Register

library IEEE;
USE IEEE.std_logic_1164.all;

entity reg_piso is
	generic ( W : integer := 8 );
        port (
            CLK : in std_logic;
            ENA : in std_logic;
            LOAD : in std_logic;
            RST : in std_logic;
            X : in std_logic_vector(4*w-1 downto 0);                   
            Y : out std_logic_vector(w-1 downto 0)
        );
end reg_piso;

architecture behavioral of piso is
	
    type bus_array is array (3 downto 0) of std_logic_vector(W-1 downto 0);
    signal REG, MUX : bus_array;

begin

    MUX(3) <= X(4*W-1 downto 3*W);
    
    mux_gen : for i in 2 downto 0 generate
        MUX(i) <= X((i+1) * W-1 downto i*W) WHEN LOAD = '1' ELSE REG(i+1);
    end generate;

    regx_gen : for i in 3 downto 0 generate
        regx : process ( CLK )
            begin
                if rising_edge(CLK) then
                    if RST = '1' then
                        REG(i) <= (others => '0');
                    elsif ENA = '1' then
                        REG(i) <= MUX(i);
                    end if;  
                end if;
        end process;
    end generate;

    y <= reg(0);

end behavioral;
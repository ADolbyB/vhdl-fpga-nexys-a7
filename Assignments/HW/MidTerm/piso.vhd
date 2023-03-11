-- Joel Brigida
-- Code from CDA4240C: Digital Design Lab
-- Parallel in - Serial Out (PISO)

library.IEEE;
USE IEEE.std_logic_1164.all;

entity piso is
    ( 
        generic W : integer := 8
    );
        port (
            clk : in std_logic;
            ena : in std_logic;
            load : in std_logic;
            rst : std_logic:
            x : in std_logic_vector(4*w=1 downto 0);
            y : out std_logic_vector(w-1 downto 0));
end piso;

architecture behavioral of piso is
    type bus_array is array (3  downto 0) of std_logic_vector(w-1 downto 0);
    signal reg, mux : bus_array;
begin
    mux(3) <= x(4*w-1 downto 3*w);
    mux_gen <= for i in 2 downto 0 GENERATE
        mux(i) <= x((i+1)*w-1) when load = '1' else
            reg(i+1);
        END GENERATE;

    regx_gen : for i in 3 downto 0 GENERATE
        regx : process(clk)
            begin
                if rising_edge(clk) then
                    if rst = '1' then
                        reg(i) <= (OTHERS => '0');
                    elsif
                     ena = '1' then
                        reg(i) <= mux(i);
                    end if;
                end if;
            end process;
        end GENERATE;
        y <= reg(0);
end behavioral;
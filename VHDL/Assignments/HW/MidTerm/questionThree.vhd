-- Joel Brigida
-- Digital Design Lab
-- Practice Exam Question 3

library IEEE;
USE IEEE.std_logic_1164.all;

entity questionThree is
    generic(N : integer := 8); -- Note N must be larger than 2.
    PORT (
        CLK : in std_logic;
        RESET : in std_logic;
        X : in std_logic_vector(N - 1 downto 0);
        Y : in std_logic_vector(2 downto 0);
        CTRL : in std_logic_vector(2 downto 0);
        Z : out std_logic_vector(N - 1 downto 0)
    );
end questionThree;

architecture behavioral of questionThree IS

signal select1 : std_logic;
signal regEnable : std_logic;
signal regState : std_logic_vector(N - 1 downto 0);

select1 <= NOT Y(2) when ctrl(0) = '1' else Y(0); -- What?

enable_mux_process : process(X, Y, CTRL)
begin
    case ctrl is
        when "000" => regEnable <= X(0) AND Y(0);
        when "001" => regEnable <= select1;
        when "101" => regEnable <= X(0) AND Y(0);
        when "110" => regEnable <= '1';
        when "111" => regEnable <= '0';
        when OTHERS => regEnable <= X(1) NAND Y(1);
    end case;
end process;

reg_process : process(CLK, RESET)
begin
    if reset = '1' then -- Logic HI reset
        regState <= (others => '0');
    elsif rising_edge(CLK) then
        if regEnable = '1' then -- Write Enable = Logic Hi
            regState = X;
        end if;
    end if;
end process;

z <= regState;

end behavioral;
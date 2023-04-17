-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an example of an 4-bit Parallel Load Register
-- This Register uses 4 Flip Flops.

library IEEE;
USE IEEE.std_logic_1164.all;

Entity reg_4bit_parallel is
    PORT (
        D : IN std_logic_vector(3 downto 0);
        Enable : IN std_logic;
        Load : IN std_logic;    -- Load = 1: [Q3, Q2, Q1, Q0]
        ShiftIn : IN std_logic; -- Load = 0: [ShiftIn, Q3, Q2, Q1]
        Clock : IN std_logic;
        Q : OUT std_logic_vector(3 downto 0)
    );
end entity reg_4bit_parallel;

architecture behavioral of reg_4bit_parallel is
    signal QT : std_logic_vector(3 downto 0);
begin
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Enable = '1' then
                if Load = '1' then -- Do Not Shift In
                    QT <= D;
                else               -- Shift In a bit, Drop Q0.
                    QT <= ShiftIn & QT(3 downto 1);
                end if;
            end if;
        end if;
    end process;
    Q <= QT;
end behavioral;
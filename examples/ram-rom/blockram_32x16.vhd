-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an example of True Dual Port Block Ram.
-- The 1st port is write 1st, 2nd port is read 1st.

library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity blockram_32x16 is
    port(
            -- Port 1
        CLK_1 : IN std_logic;
        WE_1 : IN std_logic;
        DATA_1 : IN std_logic_vector(15 downto 0);
        ADDR_1 : IN std_logic_vector(4 downto 0);
        DOUT_1 : OUT std_logic_vector(15 downto 0);
        -- Port 2
        CLK_2 : IN std_logic;
        WE_2 : IN std_logic;
        DATA_2 : IN std_logic_vector(15 downto 0);
        ADDR_2 : IN std_logic_vector(4 downto 0);
        DOUT_2 : OUT std_logic_vector(15 downto 0);
    );
    end entity;

architecture Behavioral of blockram_32x16 is
    
    type type_ram is array(0 to 31) of std_logic_vector(15 downto 0);
    signal RAM : type_ram;

    process(CLK_1)
    begin
        IF rising_edge(CLK_1)
            IF WE_1 = '1' THEN
                RAM(to_integer(unsigned(ADDR_1))) <= DATA_1;
                DOUT_1 <= DATA_1; -- Write 1st
            ELSE
                DOUT_1 <= RAM(to_integer(unsigned(ADDR_1)));
            END IF;
        END IF;
    END PROCESS;

    process(CLK_2)
    begin
        IF rising_edge(CLK_2)
            IF WE_2 = '1' THEN
                RAM(to_integer(unsigned(ADDR_2))) <= DATA_2;
            END IF;
            DOUT_2 <= RAM(to_integer(unsigned(ADDR_2))); -- Read 1st
        END IF;
    END PROCESS;

end Behavioral;
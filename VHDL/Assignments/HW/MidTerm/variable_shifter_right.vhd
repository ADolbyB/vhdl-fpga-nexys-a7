-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Practice Exam Question 9
-- This is a 16 bit variable arithmetic shifter which rotates right.
-- Operation Performed: Z = X >> Y
-- X is a 16 bit signed.
-- Y is an 8 bit unsigned.
-- This is a DATAFLOW example using FOR-GENERATE statements.

library IEEE;
USE IEEE.std_logic_1164.all;

entity variable_shifter_right is
    PORT(
        X : IN std_logic_vector(15 downto 0);
        Y : IN std_logic_vector(7 downto 0);
        Z : OUT std_logic_vector(15 downto 0)
    );
end variable_shifter_right;

architecture mixed of variable_shifter_right is
    
    TYPE array16 IS ARRAY (0 to 4) OF std_logic_vector(15 downto 0);
    SIGNAL XL : array16;
    SIGNAL XR : array16;

begin
    XL(0) <= X;
    G : FOR i in 0 to 3 GENERATE
        SHIFT_I : entity work.fixed_shifter_right(dataflow) -- Note that program may crash if this dependency is missing
        GENERIC MAP (L => 2 ** i)
        PORT MAP(
            a => XL(i),
            y => XR(i)
        );
    XL(i + 1) <= XL(i) WHEN Y(i) = '0' ELSE XR(i);
    end generate;

    Z <= XL(4) WHEN (Y(7) OR Y(6) OR Y(5) OR Y(4)) = '0'
        ELSE (OTHERS => X(15));

    end mixed;

library IEEE;
USE IEEE.std_logic_1164.all;

entity fixed_shifter_right IS
    GENERIC (L : INTEGER := 1);
    PORT(
        A : IN std_logic_vector(15 downto 0);
        Y : OUT std_logic_vector(15 downto 0)
    );
end fixed_shifter_right;

architecture dataflow of fixed_shifter_right is
    
begin

    Y(15-L downto 0) <= A(15 downto L);
    Y(15 downto 15-L+1) <= (OTHERS => A(15));

end dataflow;
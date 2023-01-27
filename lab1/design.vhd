library ieee;
use ieee.std_logic_1164.all;

entity if_then_else is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
    );
end if_then_else;

architecture behavioral of if_then_else is
    -- Declarations
    begin
        -- Instantiations
        P1: process(X, Y)
        begin
            if (X = Y) then
                Z <= '1';
            else
                Z <= '0';
            end if;
        end process;
end behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity when_else is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
    );
end when_else;

architecture dataflow of when_else is
    -- Declarations
    begin
        -- Instantiations
        Z <= '1' when (X = Y) else '0';
    
end dataflow;

library ieee;
use ieee.std_logic_1164.all;

entity boolean_equation is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
    );
end boolean_equation;

architecture dataflow of boolean_equation is
    -- Declaration
    signal temp: std_logic_vector(3 downto 0);

begin

    temp(0) <= NOT X(0) AND NOT X(1) AND NOT Y(0) AND NOT Y(1); -- case for 00 00
    temp(1) <= NOT X(0) AND     X(1) AND NOT Y(0) AND     Y(1); -- case for 01 01
    temp(2) <=     X(0) AND NOT X(1) AND     Y(0) AND NOT Y(1); -- case for 10 10
    temp(3) <=     X(0) AND     X(1) AND     Y(0) AND     Y(1); -- case for 11 11
    
    z <= temp(3) OR temp(2) OR temp(1) OR temp(0); -- If any temp values == 1 then set z to 1

end dataflow;

library ieee;
use ieee.std_logic_1164.all;
Library UNISIM;
use UNISIM.vcomponents.all;

entity LUT_primitive is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
    );
end LUT_primitive;

architecture primitive of LUT_primitive is
    begin
        LUT4_instance: LUT4
        generic map(
            INIT => X"8421") -- Hex for 1000 0100 0010 0001 (Truth where Inputs Match)
        port map (
            O => Z,     -- LUT general output
            I0 => X(0), -- LUT input
            I1 => X(1), -- LUT input
            I2 => Y(0), -- LUT input
            I3 => Y(1)  -- LUT input
        );
end primitive;

library ieee;
use ieee.std_logic_1164.all;

entity comparator_top is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
    );
end comparator_top;

architecture structural of comparator_top is
-- Component Declarations
component if_then_else is
    port( 
        X : in std_logic_vector (1 downto 0);
        Y : in std_logic_vector (1 downto 0);
        Z : out std_logic 
        );
end component;

component when_else is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
        );
end component;

component boolean_equation is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
        );
end component;

component LUT_primitive is
    port(
        X : in std_logic_vector(1 downto 0);
        Y : in std_logic_vector(1 downto 0);
        Z : out std_logic
        );
end component;

begin
    -- Component Port Maps
    if_then_else0 : if_then_else 
        port map(
            X => X,
            Y => Y,
            Z => Z(3)
        );
    when_else0 : when_else
        port map(
            X => X,
            Y => Y,
            Z => Z(2)
        );
    boolean_equation0 : boolean_equation 
        port map(
            X => X,
            Y => Y,
            Z => Z(1)
        );
    LUT_primitive0 : LUT_primitive 
        port map(
            X => X,
            Y => Y,
            Z => Z(0)
        );
end structural;


-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an Example of package usage to create a Priority Resolver.

library IEEE;
USE IEEE.std_logic_1164.all;
USE work.gates_pkg.all; -- Import local package

entity priority_resolver1 is
    PORT(
        R : IN std_logic_vector(5 downto 0);
        S : IN std_logic_vector(1 downto 0);
        CLK : IN std_logic;
        EN : IN std_logic;
        T : OUT std_logic_vector(3 downto 0)
    );
end priority_resolver1;

architecture structural of priority_resolver1 is
    SIGNAL P : std_logic_vector(3 downto 0);
    SIGNAL Q : std_logic_vector(1 downto 0);
    SIGNAL Z : std_logic_vector(3 downto 0);
    SIGNAL ENABLE : std_logic;

begin

    U1 : mux2to1 
        PORT MAP(
            W0 => R(0),
            W1 => R(1),
            S => S(0),
            F => P(0)
        );
    P(1) <= R(2);
    P(2) <= R(3);

    U2 : mux2to1
        PORT MAP(
            W0 => R(4),
            W1 => R(5),
            S => S(1),
            F => P(3)
        );

    U3 : priority
        PORT MAP(
            W => P,
            Y => Q,
            Z => ENABLE
        );

    U4 : dec2to4
        PORT MAP(
            W => Q,
            EnableD => ENABLE,
            Y => Z
        );
    
    U5 : regn
        GENERIC MAP (N => 4)
        PORT MAP(
            D => Z,
            EnableR => EN,
            Clock => CLK,
            Q => T
        );

end structural;
-- Joel Brigida
-- CDA4240C: Digital Design Lab
-- This is the Top Level Wrapper File for a Priority Resolver Test Project
-- Uses 2 Muxes, a 4to2 Priority Encoder, a 2to4 decoder, and N-bit Registers.

library ieee;
USE ieee.std_logic_1164.all;

ENTITY priority_resolver is
    PORT (
        R : IN std_logic_vector(5 downto 0);
        S : IN std_logic_vector(1 downto 0);
        CLK : IN std_logic;
        EN : IN std_logic;
        T : OUT std_logic_vector(3 downto 0)
    );
END priority_resolver;

ARCHITECTURE structural OF priority_resolver IS

    SIGNAL P : std_logic_vector(3 downto 0);
    SIGNAL Q : std_logic_vector(1 downto 0);
    SIGNAL Z : std_logic_vector(3 downto 0);
    SIGNAL ENA : std_logic;

component mux2to1 is
    PORT(
        W0, W1, S : IN  std_logic;
        F : OUT std_logic
    );
end component;

component pri4to2encode IS
    PORT(
        W : IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- 4 bit input
        Y : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bit output
        Z : OUT STD_LOGIC
    );
END component;

component decode2to4 IS
    PORT(
        W : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bit bus w in
        EN : IN STD_LOGIC;
        Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- 4 bit bus y out
    );
end component;

component reg_Nbit_en is
    generic ( N : integer := 8 ); -- Generic Declaration for N = 16 bits
    PORT (
        Clock, Enable : IN std_logic; -- Enable instead of Reset
        D : IN std_logic_vector(N-1 downto 0);
        Q : OUT std_logic_vector(N-1 downto 0)
    );
end component;
    
BEGIN

    U1 : mux2to1 -- 1st Top Layer Mux
        PORT MAP(
            W0 => R(0),
            W1 => R(1),
            S => S(0),
            F => P(0)
        );

    P(1) <= R(2);
    P(2) <= R(3);
    
    U2 : mux2to1 -- 2nd Top Layer Mux
        PORT MAP(
            W0 => R(4),
            W1 => R(5),
            S => S(1),
            F => P(3)
        );

    U3 : pri4to2encode
        PORT MAP(
            W => P,
            Y => Q,
            Z => ENA
        );

    U4 : decode2to4
        PORT MAP(
            W => Q,
            EN => ENA,
            Y => Z
        );
        
    U5 : reg_Nbit_en
        GENERIC MAP (N => 4)
        PORT MAP(
            D => Z,
            ENABLE => EN,
            CLOCK => CLK,
            Q => T
        );
    
END structural;
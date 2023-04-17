-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is an Example of a package of gates

library IEEE;
USE IEEE.std_logic_1164.all;

PACKAGE gates_pkg IS

    component mux2to1
        PORT(
            W0, W1, S : IN std_logic;
            F : OUT std_logic
        );
    end component;

    component priority
        PORT(
            W : IN std_logic_vector(3 downto 0);
            Y : OUT std_logic_vector(1 downto 0);
            Z : OUT std_logic
        );
    end component;

    component dec2to4
        PORT(
            W : IN std_logic_vector(1 downto 0);
            EnableD : IN std_logic;
            Y : OUT std_logic_vector(0 to 3)
        );
    end component;

    component regn
        generic(N : integer := 8);
        PORT(
            D : IN std_logic_vector(N-1 downto 0);
            EnableR, Clock : IN std_logic;
            Q : OUT std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Any constants go here...Examples:
    CONSTANT init_value : std_logic_vector(3 downto 0) := "0100"; -- Binary
    CONSTANT ANDA_EXT : std_logic_vector(7 downto 0) := X"B4"; -- Hexadecimal
    CONSTANT counter_width : integer := 16;
    CONSTANT clk_period : TIME := 20 ns;

END PACKAGE;
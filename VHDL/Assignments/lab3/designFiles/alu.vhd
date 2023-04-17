-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the wrapper file for the Arithmetic Logic Unit.
-- Note that the multiplexer is written directly in the ALU.
-- The multiplexer does not need to be a separate component in this case.

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    generic(N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0); -- 6 bit input signals
        SEL : IN std_logic_vector(3 downto 0);    -- 4 bit select
        R : OUT std_logic_vector(N-1 downto 0)    -- 6 bit output signal
    );

end entity alu;

architecture structural of alu is

component adder is
    generic(N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0);
        SEL : IN std_logic_vector(1 downto 0);    -- 2 bit select for adder 
        ADDER_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end component;

component mult is
    generic(N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0);
        SEL : IN std_logic;                       -- Only need LSB, MSB is "Don't Care"
        MULT_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end component;

component logic_unit is
    generic(N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0);
        SEL : IN std_logic_vector(1 downto 0);    -- 2 bit select for logic unit
        LOGIC_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end component;

component shifter is
    generic(
        N : integer := 6;
        M : integer := 3
    );
    PORT(
        A : IN std_logic_vector(N-1 downto 0);  -- 6 bit input for A    
        B : IN std_logic_vector(M-1 downto 0);  -- 3 bit input for B
        SEL : IN std_logic_vector(1 downto 0);  -- 2 bit select for bit shifter
        SHIFT_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end component;
    
    -- Intermediate Connections
    SIGNAL ADD_RESULT : std_logic_vector(N-1 downto 0);
    SIGNAL MULT_RESULT : std_logic_vector(N-1 downto 0);
    SIGNAL LOGIC_RESULT : std_logic_vector(N-1 downto 0);
    SIGNAL SHIFT_RESULT : std_logic_vector(N-1 downto 0); 

begin

    adder_inst: adder -- instantiate adder
        generic map(N => N)
        port map (
            SEL => SEL(1 downto 0),
            A => A,
            B => B,
            ADDER_OUT => ADD_RESULT -- PORT(COMPONENT) => WRAPPER(TOP LAYER)
    );

    mult_inst : mult  -- instantiate multiplier
        generic map(N => N)
        port map (
            SEL => SEL(0),
            A => A,
            B => B,
            MULT_OUT => MULT_RESULT -- PORT(COMPONENT) => WRAPPER(TOP LAYER)
        );

    logic_inst : logic_unit  -- instantiate logic_unit
       generic map(N => N)
       port map (
           SEL => SEL(1 downto 0),
           A => A,
           B => B,
           LOGIC_OUT => LOGIC_RESULT -- PORT(COMPONENT) => WRAPPER(TOP LAYER)
       );

    shifter_inst : shifter  -- instantiate bit shifter
        generic map(N => N)
        port map (
            SEL => SEL(1 downto 0),
            A => A,
            B => B(2 downto 0),
            SHIFT_OUT => SHIFT_RESULT -- PORT(COMPONENT) => WRAPPER(TOP LAYER)
        );

    -- Choose Operation of ALU:
    WITH SEL(3 downto 2) SELECT            -- ALU Wrapper SEL signal
            R <= ADD_RESULT WHEN "00",     -- Use ADDER
                 MULT_RESULT  WHEN "01",   -- Use MULTIPLIER
                 LOGIC_RESULT WHEN "10",   -- Use LOGIC_UNIT
                 SHIFT_RESULT WHEN OTHERS; -- Use BIT SHIFTER

end structural;
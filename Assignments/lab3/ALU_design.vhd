-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the complete design in a single File for Arithmetic Logic Unit.

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Adder Component Entity
entity adder is
generic(N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0);
        SEL : IN std_logic_vector(1 downto 0);
        ADDER_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end entity;

architecture dataflow of adder is
    
    -- Create Temporary Signals
    signal A_Long : unsigned(N downto 0);        -- Extra Bit for Carry Where Needed
    signal B_Long : unsigned(N downto 0);        -- Extra Bit for Carry Where Needed
    signal B_Compliment : signed(N downto 0);    -- Extra Bit for Carry Where Needed
    signal Add_Temp : unsigned(N downto 0);      -- 7 bit long that performs A_Long + B_Long
    signal Subtract_Temp : signed(N downto 0);   -- A_Long + B_Compliment
    signal Carry_Temp : unsigned(N-1 downto 0);  -- "00000" & Add_Temp MSB
    signal Borrow_Temp : unsigned(N-1 downto 0); -- "00000" & Subtract_Temp MSB
    
begin
    
    -- Signal Assignment
    A_Long <= '0' & unsigned(A); -- A_Long is 7 bits to hold a Carry if needed
    B_Long <= '0' & unsigned(B); -- B_Long is 7 bits
    
    -- ADDER FUNCTION
    Add_Temp <= A_Long + B_Long; -- Unsigned Addition of 7 bit A & B Can Contain the Carry

    -- CARRY FUNCTION
    Carry_Temp <= "00000" & Add_Temp(6); -- MSB of Add_Temp is the Carry Bit
    
    -- SUBTRACTION FUNCTION
    B_Compliment <= (NOT signed(B_Long)) + 1;       -- 2's Compliment for Subtraction
    Subtract_Temp <= signed(A_Long) + B_Compliment; -- A + (-B) = A - B
    
    -- BORROW FUNCTION
    Borrow_Temp <= "00000" & Subtract_Temp(6); -- MSB of Subtract_Temp is the Borrow Bit
    
    with SEL SELECT -- 6 bit outputs
        ADDER_OUT <= std_logic_vector(Add_Temp(N-1 downto 0)) when "00",
                     std_logic_vector(Carry_Temp(N-1 downto 0)) when "01",
                     std_logic_vector(Subtract_Temp(N-1 downto 0)) when "10",
                     std_logic_vector(Borrow_Temp(N-1 downto 0)) when "11",
                     "000000" when OTHERS;

end dataflow;

library IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all; -- CONV_STD_LOGIC_VECTOR Function

-- Multiplier Component Entity
entity mult is
    GENERIC (N : integer := 6);
    PORT(
        A, B : IN std_logic_vector(N-1 downto 0);
        SEL : IN std_logic; -- Only need one bit since there are only 2 possible operations
        MULT_OUT : OUT std_logic_vector(N-1 downto 0)
    );
end mult;

architecture dataflow of mult is

    SIGNAL total_result : unsigned(11 downto 0); -- 12 bit long result
    SIGNAL high_result : unsigned(N-1 downto 0); -- MSB 6 bits
    SIGNAL low_result : unsigned(N-1 downto 0);  -- LSB 6 bits

begin

    total_result <= unsigned(A) * unsigned(B);   -- Perform Unsigned Multiplication
    
    high_result <= total_result(2*N-1 downto N); -- 2N-1 = 11, N = 6
    low_result <= total_result(N-1 downto 0);    -- N-1 = 5

    MULT_OUT <= std_logic_vector(high_result(N-1 downto 0)) -- Return Upper 6 bits
        WHEN SEL = '1' 
        ELSE std_logic_vector(low_result(N-1 downto 0));    -- Return Lower 6 bits

end dataflow;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Logic Unit Component Entity
entity logic_unit is
    generic (N: integer := 6);
    port (
        A, B : IN std_logic_vector(N-1 downto 0);       -- 6 bit input signals
        SEL : IN std_logic_vector(1 downto 0);          -- 2 bit selects Logic Operation
        LOGIC_OUT : OUT std_logic_vector(N-1 downto 0)  -- 6 bit output signal
    );
end logic_unit;

architecture dataflow of logic_unit is
    -- define signals to store the temp results
begin
    WITH SEL SELECT
        LOGIC_OUT <= NOT A when "00",
                     A AND B when "01",
                     A OR B when "10",
                     A XOR B when "11",
                     "000000" when OTHERS;

end dataflow;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- SHIFT_LEFT, SHIFT_RIGHT & TO_INTEGER Functions

-- Bit Shifter Component Entity
entity shifter is
    generic(
        N : integer := 6;
        M : integer := 3
    );
    PORT(
        A : IN std_logic_vector(N-1 downto 0); -- 6 bits for input A
        B : IN std_logic_vector(M-1 downto 0); -- 3 bits for input B
        SEL : IN std_logic_vector(1 downto 0);
        SHIFT_OUT : OUT std_logic_vector(N-1 downto 0)
    );

end entity;

architecture dataflow of shifter is
    
    SIGNAL A_Unsigned : unsigned(N-1 downto 0);
    SIGNAL A_Signed : signed(N-1 downto 0);
    SIGNAL B_Integer : integer range 0 to 7;
    
    SIGNAL Logic_Left : std_logic_vector(N-1 downto 0); 
    SIGNAL Logic_Right : std_logic_vector(N-1 downto 0);
    SIGNAL Arith_Right : std_logic_vector(N-1 downto 0);

begin

    B_Integer <= to_integer(unsigned(B)); -- B Becomes 3 in this case
    A_Signed <= signed(A);
    A_Unsigned <= unsigned(A);
    
    Logic_Left <= std_logic_vector(shift_left(A_Unsigned, B_Integer));
    Logic_Right <= std_logic_vector(shift_right(A_Unsigned, B_Integer));
    Arith_Right <= std_logic_vector(shift_right(A_signed, B_Integer));

    WITH SEL SELECT
        SHIFT_OUT <= Logic_Left WHEN "00",     -- Logic Shift Left
                        Logic_Left WHEN "01",  -- Logic Shift Left
                        Logic_Right WHEN "10", -- Logic Shift Right
                        Arith_Right WHEN "11", -- Arith Shift Right
                        "000000" WHEN OTHERS;  -- Default Case

end dataflow;

-- Top Level Wrapper
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
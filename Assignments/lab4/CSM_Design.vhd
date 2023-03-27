-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the complete Carry-Save Multiplier in one file.

-- FULL_ADDER COMPONENT
library ieee;
use ieee.std_logic_1164.all;

ENTITY full_adder is
    PORT(
        A : IN STD_LOGIC;     -- 1 bit input and output for each adder instance
        B : IN STD_LOGIC;
        CIN : IN STD_LOGIC;   -- Carry In Bit
        COUT : OUT STD_LOGIC; -- Carry Out Bit
        SUM : OUT STD_LOGIC
    );
END ENTITY full_adder;

architecture dataflow OF full_adder is
    -- Define Intermediate Signal
    signal AB : STD_LOGIC;
begin

    AB <= A XOR B; 
    SUM <= AB XOR CIN;
    COUT <= (A AND B) OR (AB AND CIN);

end dataflow;

-- CARRY_SAVE_MULT COMPONENT
library ieee;
use ieee.std_logic_1164.all;

entity carry_save_mult is
    GENERIC (N : integer := 8); -- N = Size of operands
    PORT(
        A : IN std_logic_vector(N-1 downto 0);
        B : IN std_logic_vector(N-1 downto 0);
        P : OUT std_logic_vector(2*N-1 downto 0) -- n bit * n bit = 2n bit result
    );
end carry_save_mult;

architecture structural of carry_save_mult is
    
    COMPONENT full_adder is
        PORT(
            A : IN STD_LOGIC;     -- 1 bit input and output for each adder instance
            B : IN STD_LOGIC;
            CIN : IN STD_LOGIC;   -- Carry In Bit
            COUT : OUT STD_LOGIC; -- Carry Out Bit
            SUM : OUT STD_LOGIC
        );
    END COMPONENT;

    -- variable array of n-bit std_logic_vector
    type arr2d is array (integer range <>) of std_logic_vector(n-1 downto 0);
    signal ab : arr2d(0 to n-1); -- signal ab has dimensions (n x n): AND gate array

    -- full_adder signals, all have dimension ((n-1) x n)
    signal FA_a    : arr2d(0 to n-2);
    signal FA_b    : arr2d(0 to n-2);
    signal FA_cin  : arr2d(0 to n-2);
    signal FA_sum  : arr2d(0 to n-2);
    signal FA_cout : arr2d(0 to n-2);
    signal PROD    : arr2d(0 to 2*n-1); -- Product of Multiplication
    
begin
    -- ab(0)(n-1)
    GEN_AB_ROWS: for i in 0 to n-1 generate
        GEN_AB_COLS: for j in 0 to n-1 generate
            AB(i)(j) <= A(i) AND B(j); -- Generate AND gate array signal outputs
        end generate;                  -- ab(i)(j) = a(i) AND b(j)
    end generate;
    
    -- Figure 3 shows that we will use ((n-1) x n) full adders
    -- use nested for-generate to instantiate each full_adder component.
    -- ports are mapped to each bit of the 2D-arrays FA_a, FA_b, FA_cin, FA_sum, FA_cout

    -- after instantiating the full adders, we need to assign values 
    -- for the inputs of the FAs.
    -- use the three patterns from the pdf to complete this part
    -- and assign values to each row.

    -- First row: Row 0 Of Adders
    FA_a(0) <= '0' & AB(0)(N-1 downto 0); -- Input A
    FA_b(0) <= AB(1)(N-1 downto 0); -- Input B
    FA_cin(0) <= AB(2)(N-2 downto 0) & '0'; -- Carry In
    
    -- Intermediate rows: Rows 1 to N-3
    -- (need an array)
    FA_a(i) <= AB(i+1)(N-1) & FA_sum(i-1)(N-1 downto 1);
    FA_b(i) <= FA_cout(i-1)(N-1 downto 0);
    FA_cin(i) <= AB(i+2)(N-2 downto 0) & '0';
    
    -- Last Row N-2 of Adders
    FA_a(N-2) <= AB(N-1)(N-1) & FA_sum(N-3)(N-1 downto 1);
    FA_b(N-2) <= FA_cout(N-3)(N-1 downto 0);
    FA_cin(N-2) <= AB(N-2)(N-2 downto 0) & '0';

    genProduct : for i in 0 to n-2 GENERATE
        PROD(i) <= PROD(i-1);
    end generate;
    -- finally, do the last steps to compute the product.
    -- These are the signals along the bottom of the block schematic
    -- Product:
    -- 1st assign Bit0 to ab(0)(0)


end structural;

-- MULTIPLIER WRAPPER
library ieee;
use ieee.std_logic_1164.all;

ENTITY mult is
    GENERIC(N : integer := 8);
    PORT(
        CLK : IN STD_LOGIC;
        A : IN std_logic_vector(N-1 downto 0);      -- 8 bit inputs
        B : IN std_logic_vector(N-1 downto 0);
        PROD : OUT std_logic_vector(2*N-1 downto 0) -- 16 bit output
    );
END mult;

architecture structural of mult is

    -- we don't need the full_adder as component here
    -- add carry_save_mult as a component
    component carry_save_mult is
    GENERIC (N : integer := 8); -- N = Size of operands
        PORT(
            A : IN std_logic_vector(N-1 downto 0);
            B : IN std_logic_vector(N-1 downto 0);
            P : OUT std_logic_vector(2*N-1 downto 0) -- n bit * n bit = 2n bit result
        );
    end component;

    signal A_reg  : std_logic_vector(7 downto 0);
    signal B_reg  : std_logic_vector(7 downto 0);
    signal PROD_s : std_logic_vector(15 downto 0);
    
begin

    c_s_m : carry_save_mult -- instantiate carry_save_mult & create Port Map
        GENERIC MAP(N => N)
        PORT MAP(
            A => A_reg,
            B => B_reg,
            P => PROD_s
        );
    

    reg_mult : process(clk)
    begin
        if rising_edge(clk) then
            -- on the rising edge, make the signals equal
            -- to the inputs and outputs carry_save_mult
            PROD <= PROD_s;
            
        end if;
    end process;

end structural;
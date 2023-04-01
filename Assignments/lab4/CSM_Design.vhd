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
    signal A_B : STD_LOGIC;
begin

    A_B <= A XOR B; 
    SUM <= A_B XOR CIN;
    COUT <= (A AND B) OR (A_B AND CIN);
    
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
    signal AB : arr2d(0 to N-1); -- signal ab has dimensions (n x n): AND gate array

    -- full_adder signals, all have dimension ((n-1) x n)
    signal FA_a    : arr2d(0 to N-2);
    signal FA_b    : arr2d(0 to N-2);
    signal FA_cin  : arr2d(0 to N-2);
    signal FA_sum  : arr2d(0 to N-2);
    signal FA_cout : arr2d(0 to N-2);
    
begin

    GEN_AB_ROWS : for i in 0 to N-1 generate
        GEN_AB_COLS : for j in 0 to N-1 generate
            AB(i)(j) <= A(i) AND B(j);      -- Generate AND gate array signal outputs
        end generate;                       -- ab(i)(j) = a(i) AND b(j)
    end generate;

    GEN_FA_ROWS : for i in 0 to N-2 generate
        GEN_FA_COLS : for j in 0 to N-1 generate
            FULLADD_inst : full_adder       -- Instantiate ((n - 1) x n) Full Adder Components
                PORT MAP(
                    A => FA_a(i)(j),
                    B => FA_b(i)(j),
                    CIN => FA_cin(i)(j),
                    COUT => FA_cout(i)(j),
                    SUM => FA_sum(i)(j)
                );        
        end generate;
    end generate;
    
    FA_a(0) <= '0' & AB(0)(N-1 downto 1);   -- Input A
    FA_b(0) <= AB(1)(N-1 downto 0);         -- Input B
    FA_cin(0) <= AB(2)(N-2 downto 0) & '0'; -- Carry In
    
    -- Intermediate rows: Rows 1 to N-3
    GEN_FA_MID_BLK : For i in 1 to N-3 GENERATE
        FA_a(i) <= AB(i+1)(N-1) & FA_sum(i-1)(N-1 downto 1);
        FA_b(i) <= FA_cout(i-1)(N-1 downto 0);
        FA_cin(i) <= AB(i+2)(N-2 downto 0) & '0';
    END Generate;
    
    -- Last Row N-2 of Adders
    FA_a(N-2) <= AB(N-1)(N-1) & FA_sum(N-3)(N-1 downto 1);
    FA_b(N-2) <= FA_cout(N-3)(N-1 downto 0);
    FA_cin(N-2) <= FA_cout(N-2)(N-2 downto 0) & '0';
    
    -- Compute Product:
    P(0) <= AB(0)(0);                               -- 1st bit has no adder to ab(0)(0) (Bit 0)
    GEN_PROD_BLK_1 : for i in 1 to N-2 generate
        P(i) <= FA_sum(i-1)(0);                     -- 1st Group Of Adders (Bits 1 to 6)
    end generate;
    GEN_PROD_BLK_2 : for i in 1 to N generate
        P(i+N-2) <= FA_sum(N-2)(i-1);               -- 2nd Group Of Adders (Bits 7 to 14)
    end generate;
    P(2*N-1) <= FA_cout(N-2)(N-1);                  -- Final COUT for Last Adder (Bit 15)

end structural;

-- MULTIPLIER WRAPPER
library ieee;
use ieee.std_logic_1164.all;

ENTITY mult is
    GENERIC(N : integer := 8);
    PORT(
        CLK : IN STD_LOGIC;
        A_mult : IN std_logic_vector(N-1 downto 0); -- 8 bit inputs
        B_mult : IN std_logic_vector(N-1 downto 0);
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

    CSM : carry_save_mult -- instantiate carry_save_mult & create Port Map
        GENERIC MAP(N => N)
        PORT MAP(
            A => A_reg,
            B => B_reg,
            P => PROD_s
        );
    
    reg_mult : process(CLK)
    begin
        if rising_edge(CLK) then
            -- on the rising edge, make the signals equal
            -- to the inputs and outputs carry_save_mult
            A_reg <= A_mult;
            B_reg <= B_mult;
            PROD <= PROD_s;
            
        end if;
    end process;

end structural;
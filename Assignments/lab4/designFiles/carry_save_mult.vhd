-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the file for the Carry-Save Multiplier Entity
-- This incorporates an N by N array of AND gates
-- And an N by N-1 array of Full Adders

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
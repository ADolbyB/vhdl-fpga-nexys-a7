-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is VHDL code for a Multiple Input Signature Register for HW4

library ieee;
USE IEEE.std_logic_1164.all;

entity misr is
    port(
        CLK_m : IN std_logic;
        RST_m : IN std_logic;
        EN_m : IN std_logic;
        C_m : IN std_logic_vector(7 downto 0);  -- External C input to AND gates
        D_x : IN std_logic_vector(7 downto 0);  -- External D Signal
        D_m : IN std_logic_vector(7 downto 0);  -- D input to Flip Flops
        Q_m : OUT std_logic_vector(7 downto 0)  -- Q out of flip flops
    );
end entity;

architecture behavioral of misr is
    
    -- D Flip Flop Component
    component d_flipflop is
        port(
            CLK : IN std_logic;
            RST : IN std_logic;
            EN : IN std_logic;
            D : IN std_logic;
            Q : OUT std_logic
        );
    end component;

    signal Q0_Sig : std_logic;                          -- Q(0) output that goes to each AND gate.
    signal Q_out : std_logic_vector(7 downto 0);        -- Q_m output signal from FFs.
    signal D_in_ff_sig : std_logic_vector(7 downto 0);  -- D Input to FFs after XOR Gate.

begin

    Q_m(0) <= Q0_sig;
    Q_m <= Q_out;

    GEN_D_IN : for i in 0 to 6 GENERATE
        D_in_ff_sig(i) <= (D_x(i) XOR (C_m(i) AND Q0_Sig) XOR Q_out(i+1));
    end generate;

    D_in_ff_sig(7) <= (D_x(7) XOR (C_m(7) AND Q0_Sig));

    -- Instantiate 8 Flip Flops
    GEN_FFS : for i in 0 to 7 generate
        D_FF : d_flipflop 
            PORT MAP(
                CLK => CLK_m,
                RST => RST_m,
                EN => EN_m,
                Q => Q_m(i),
                D => D_in_ff_sig(i)
            );
    end generate;
    
    -- Connect Individual Flip Flops to Signals
    GEN_D_SIG : for i in 0 to 7 generate
        D_in_ff_sig(i) <= D_m(i);
    end generate;
    
end architecture behavioral;

library ieee;
USE IEEE.std_logic_1164.all;

-- D Flip Flop Component
entity d_flipflop is
    port(
        CLK : IN std_logic;
        RST : IN std_logic;
        EN : IN std_logic;
        D : IN std_logic;
        Q : OUT std_logic
    );
end entity;

architecture behavioral of d_flipflop is

begin
    
    PROCESS (CLK, RST)
    BEGIN
        IF RST = '1' THEN
            Q <= '0';
        ELSIF rising_edge (CLK) THEN 
            IF EN = '1' THEN
                Q <= D;
            END IF;
        END IF;
    END PROCESS;

end architecture behavioral;
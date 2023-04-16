-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This Is a Bit Serial Multiplier

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bit_serial_mult is
	port(	
            clk: in STD_LOGIC;
            reset : in STD_LOGIC;
            A_IN : in STD_LOGIC_VECTOR(3 downto 0);
            A_en : in STD_LOGIC;	  
            B_IN : in STD_LOGIC;
            B_en : in STD_LOGIC;
            shift_in : in STD_LOGIC;
            PRODUCT : out STD_LOGIC
	    );
end bit_serial_mult;

architecture rtl of bit_serial_mult is	  

    signal A, B, Sum, Carry, Previous_Carry, ANDout: STD_LOGIC_VECTOR(3 downto 0); 
    signal s_in: STD_LOGIC;

begin	 
	
    A_reg: process(clk, reset)
        begin
            if reset='1' then	
                A <= "0000";
            elsif (rising_edge(clk)) then 
                if (A_en = '1') then
                    A <= A_IN;	
                end if;
            end if;
    end process; 

    s_in <= B_IN AND shift_in;

    B_reg: process(clk, reset)
        begin
            if reset = '1' then	
                B <= "0000";
            elsif (rising_edge(clk)) then 
                if (B_en = '1') then
                    B <= B(2 downto 0) & s_in;	
                end if;
            end if;
    end process;  

    bmul: for I in 0 to 3 generate
        
        AND_i: ANDout(I) <= A(I) AND B(I);
	    
        HA_i: if (I = 3) generate
            Carry(I)<= ANDout(I) AND Previous_Carry(I);	
            Sum(I) <= ANDout(I) XOR Previous_Carry(I);	
            end generate;
	
        FA_i: if (I/=3) generate
            Carry(I) <= (ANDout(I) AND Previous_Carry(I)) OR (SUM(I+1) 
                        AND Previous_Carry(I)) OR (ANDout(I) AND SUM(I+1));	 
            Sum(I) <= ANDout(I) XOR Previous_Carry(I) XOR SUM(I+1);
        end generate;

        FF_i: process(clk)	 
            begin
                if rising_edge(clk) then
                    if (reset = '1') then
                        Previous_Carry(I) <= '0';
                    else
                        Previous_Carry(I) <= Carry(I); 
                    end if;
                end if;
        end process;
	
    end generate;

    FF_product: process(clk) 
        begin
            if rising_edge(clk) then
                if (reset = '1') then
                    PRODUCT <= '0';
                else
                    PRODUCT <= Sum(0); 
                end if;
            end if;
    end process; 

end rtl;
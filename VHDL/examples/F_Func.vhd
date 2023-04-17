LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity F is  

    port (    
        a, b, c, d : in std_logic;
        y : out std_logic    
    );

end F;

architecture dataflow of F is

    signal  e, f, g, h: std_logic;
    signal  dec_out: std_logic_vector(3 downto 0);
    signal  En_w, mux8_sel: std_logic_vector(2 downto 0);
    signal  mux8_out: std_logic;   
    signal  fa_out: std_logic_vector(1 downto 0);

begin

    En_w <= (c xor d)  & a & b;
        with En_w select    
            dec_out <= "0001" when "100",
                       "0010" when "101",               
                       "0100" when "110",               
                       "1000" when "111",	       
                       "0000" when others;	

    e <= d;
    f <= a;
    g <= b;
    h <= c;

    mux8_sel <= e & f & g;
    
    with mux8_sel select
        mux8_out <= dec_out(3) when "000",
                    dec_out(2) when "010",
                    dec_out(1) when "011",
                    dec_out(0) when "101",
                    a xor b when others;

    fa_out <= ('0' & g) + h + c;	 
  
    y <= f when fa_out(0) = '0' else 
         e when fa_out(1) = '0' else mux8_out;

end dataflow;
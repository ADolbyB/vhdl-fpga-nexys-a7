-- VHDL program for a Full Adder
library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

ENTITY fulladd is
    PORT(
        x : IN STD_LOGIC;
        y : IN STD_LOGIC;
        cin : in STD_LOGIC;
        s : OUT STD_LOGIC;
        cout: OUT STD_LOGIC
    );
END fulladd;

architecture fullad_dataflow OF fulladd is
begin
    
    s <= x XOR y XOR cin;
    cout <= (x AND y) OR (cin AND x) OR (cin AND y);

end fullad_dataflow;
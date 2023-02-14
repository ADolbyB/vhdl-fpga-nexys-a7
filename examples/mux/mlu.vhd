library ieee;
use ieee.std_logic_1164.all;

entity mlu is
    port (
        NEG_A : in std_logic;
        NEG_B : in std_logic;
        NEG_Y : in std_logic;
        A : in std_logic;
        B : in std_logic;
        L1 : in std_logic;
        L0 : in std_logic;
        Y : out std_logic        
    );
end entity mlu;

architecture dataflow of mlu is

signal A1 : std_logic;
signal B1 : std_logic;
signal Y1 : std_logic;
signal MUX_0, MUX_1, MUX_2, MUX_3 : std_logic;
signal L : std_logic_vector(1 downto 0);

begin
    A1 <= NOT A when (NEG_A = '1')
        else A;
    B1 <= NOT B when (NEG_B = '1') 
        else B;
    Y1 <= NOT Y1 when (NEG_Y = '1')
        else Y1;

    MUX_0 <= A1 AND B1;
    MUX_1 <= A1 OR B1;
    MUX_2 <= A1 XOR B1;
    MUX_3 <= A1 XNOR B1;

    L <= L1 & L0;

    with (L) select
        Y1 <= MUX_0 when "00",
              MUX_1 when "01",
              MUX_2 when "10",
              MUX_3 when others;

end dataflow;
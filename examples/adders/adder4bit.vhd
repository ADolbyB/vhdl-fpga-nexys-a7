-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is a DATAFLOW/BEHAVIORAL example of a 4 bit ripple carry adder

library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
    port (
        x : in std_logic;
        y : in std_logic;
        cin : in std_logic;
        cout : out std_logic;
        sum : out std_logic
    );
end entity fulladder;

architecture dataflow of fulladder is
begin -- Concurrent assignment
    
    sum <= x XOR y XOR cin;
    cout <= (x AND y) OR (cin AND x) OR (cin AND y);

end dataflow;

library ieee;
use ieee.std_logic_1164.all;

entity adder4bit is
    port (
        A, B : in std_logic_vector(3 downto 0);
        CI : in std_logic;
        S : out std_logic_vector(3 downto 0);
        CO : out std_logic
    );
end entity adder4bit;

architecture structure of adder4bit is

component fulladder
    port (
        x, y, cin : in std_logic;
        cout, sum : out std_logic
    );
end component;

signal C : std_logic_vector(3 downto 1);

begin -- Instantiate four copies of the full adder
    
    FA0 : fulladder port map(A(0), B(0), CI, C(1), S(0));
    FA1 : fulladder port map(A(1), B(1), C(1), C(2), S(1));
    FA2 : fulladder port map(A(2), B(2), C(2), C(3), S(2));
    FA3 : fulladder port map(A(3), B(3), C(3), CO, S(3));

end structure;
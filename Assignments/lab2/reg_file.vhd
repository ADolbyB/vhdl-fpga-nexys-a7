-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Top Level Wrapper File for Register Components

library ieee;
use ieee.std_logic_1164.all;

entity reg_file is
    generic (n : integer := 4);
    port(
        clk : in std_logic;
        rst : in std_logic;
        we : in std_logic;
        addr : in std_logic_vector(2 downto 0);
        din : in std_logic_vector(3 downto 0);
        dout : out std_logic_vector(3 downto 0)
    );
end entity reg_file;

architecture structural of reg_file is

component mux_8to1 is
    generic(n : integer := 4); -- each input is 'n' bits wide
    port(
        sel : in std_logic_vector (2 downto 0); -- 8 bit select
        din0 : in std_logic_vector (n-1 downto 0);
        din1 : in std_logic_vector (n-1 downto 0);
        din2 : in std_logic_vector (n-1 downto 0);
        din3 : in std_logic_vector (n-1 downto 0);
        din4 : in std_logic_vector (n-1 downto 0);
        din5 : in std_logic_vector (n-1 downto 0);
        din6 : in std_logic_vector (n-1 downto 0);
        din7 : in std_logic_vector (n-1 downto 0);
        dout : out std_logic_vector (n-1 downto 0)
    );
end component;

component decoder_3to8 is
    PORT(
        en : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bit bus din in
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- 8 bit bus dout out
    );
end component;

component reg_module is
    generic(n : integer := 4);
    port(
        clk : in std_logic;
        rst : in std_logic;
        we : in std_logic;
        din : in std_logic_vector (n-1 downto 0);
        dout : out std_logic_vector (n-1 downto 0)
    );
end component;

-- Register Enable
signal reg_en : std_logic_vector(7 downto 0);

-- MUX Inputs: Create a new variable type
type array_8of4 is array (0 to 7) of std_logic_vector(3 downto 0);
signal mux_in : array_8of4;

begin

decoder_instantiate : decoder_3to8 -- inputs and outputs of component
port map (
        en => we,       -- PORT(COMPONENT) => WRAPPER(TOP LAYER)
        din => addr,    -- PORT(COMPONENT) => WRAPPER(TOP LAYER)
        dout => reg_en  -- PORT(COMPONENT) => WRAPPER(TOP LAYER)
    );
    
mux_instantiate : mux_8to1
generic map (n => 4)
port map (
        sel  => addr,
        din0 => mux_in(0),
        din1 => mux_in(1),
        din2 => mux_in(2),
        din3 => mux_in(3),
        din4 => mux_in(4),
        din5 => mux_in(5),
        din6 => mux_in(6),
        din7 => mux_in(7),
        dout => dout
    );
    
reg_module_generate : for i in 0 to 7 generate
    reg_module_instantiate : reg_module
    generic map (n => 4) -- Connecting REGISTERS to the MUX
    port map (
        clk => clk,
        rst => rst,
        we => reg_en(i),
        din => din,
        dout => mux_in(i) -- REG_OUT => MUX_IN
    );
end generate;

end architecture structural;
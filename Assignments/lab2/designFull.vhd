-- Joel Brigida
-- CDA4240C: Digital Design Lab
-- This is all design files combined into a single file:
-- decoder_3to8.vhd, mux_8to1.vhd, reg_file.vhd & reg_module.vhd

-- 8to1 MUX
library ieee;
use ieee.std_logic_1164.all;

entity mux_8to1 is
    generic(n : integer := 4); -- each input is 'n' bits wide
    port(
        sel : in std_logic_vector (2 downto 0); -- 3 bit select (8 addresses)
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
end mux_8to1;

architecture dataflow of mux_8to1 is
begin
    with sel select
        dout <= din0 WHEN "000", -- double quotes when > 1 bit signal
                din1 WHEN "001",
                din2 WHEN "010",
                din3 WHEN "011",
                din4 WHEN "100",
                din5 WHEN "101",
                din6 WHEN "110",
                din7 WHEN OTHERS;

end dataflow;

-- Registers (x8)
library ieee;
use ieee.std_logic_1164.all;

entity reg_module is
    generic(n : integer := 4);
    port(
        clk : in std_logic;
        rst : in std_logic;
        we : in std_logic;
        din : in std_logic_vector (n-1 downto 0);
        dout : out std_logic_vector (n-1 downto 0)
    );
end reg_module;

architecture behavioral of reg_module is

begin
    -- N bit register w/ enable (always syncronous)
    -- N bit register with ASYNC ACTIVE LOW Reset
    process (clk, rst) -- Async Reset
    begin
        if rst = '0' then
            dout <= (OTHERS => '0'); -- Set all N bits to 0
        elsif rising_edge(clk) then
            if we = '1' then
                dout <= din;
            end if;
        end if;
    end process;

end behavioral;

-- 3to8 Decoder:
library ieee;
use ieee.std_logic_1164.all;

entity decoder_3to8 is
    PORT(
        en : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(2 DOWNTO 0);  -- 3 bit bus w in
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- 8 bit bus y out
    );
end entity decoder_3to8;

architecture dataflow OF decoder_3to8 IS
    SIGNAL enDin : STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
    enDin <= en & din; -- MSB = en, LSB = din
    WITH enDin SELECT
        dout <= "00000001" WHEN "1000", -- MSB is the ENABLE bit
                "00000010" WHEN "1001",
                "00000100" WHEN "1010",
                "00001000" WHEN "1011",
                "00010000" WHEN "1100",
                "00100000" WHEN "1101",
                "01000000" WHEN "1110",
                "10000000" WHEN "1111",
                "00000000" WHEN OTHERS;
end dataflow;

-- Top Level Wrapper File for Overall Design
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
        sel : in std_logic_vector (2 downto 0); -- 3 bit select
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
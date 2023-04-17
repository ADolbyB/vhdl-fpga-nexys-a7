-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This File Implements the Functionality Of The 7 Segment Display.

library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_7seg is
    port (
        clk                : in  std_logic;
        rst                : in  std_logic;

        soda_reserved_i    : in  std_logic;
        soda_price_i       : in  std_logic_vector(11 downto 0);
        deposit_amt_i      : in  std_logic_vector(11 downto 0);

        anode_o            : out std_logic_vector(7 downto 0);
        cathode_o          : out std_logic_vector(7 downto 0) 
    );
end vending_machine_7seg;

architecture mixed of vending_machine_7seg is
    component bin_bcd is
        port (
            clk     : in  std_logic;
            din     : in  std_logic_vector(11 downto 0);
            dout    : out std_logic_vector(15 downto 0)
        );
    end component;

    component decoder_bcd_7seg is
        port (
            invalid : in  std_logic;
            din     : in  std_logic_vector(3 downto 0);
            dout    : out std_logic_vector(6 downto 0)
        );
    end component;

    component display_7seg is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            digit0  : in  std_logic_vector(7 downto 0);
            digit1  : in  std_logic_vector(7 downto 0);
            digit2  : in  std_logic_vector(7 downto 0);
            digit3  : in  std_logic_vector(7 downto 0);
            digit4  : in  std_logic_vector(7 downto 0);
            digit5  : in  std_logic_vector(7 downto 0);
            digit6  : in  std_logic_vector(7 downto 0);
            digit7  : in  std_logic_vector(7 downto 0);
            anode   : out std_logic_vector(7 downto 0);
            cathode : out std_logic_vector(7 downto 0) 
        );
    end component;

    signal soda_reserved_r     : std_logic;
    signal soda_price_r        : std_logic_vector(11 downto 0);
    signal deposit_amt_r       : std_logic_vector(11 downto 0);

    signal soda_price_bcd_s    : std_logic_vector(15 downto 0);
    signal deposit_amt_bcd_s   : std_logic_vector(15 downto 0);

    signal digit0_s            : std_logic_vector(7 downto 0);
    signal digit1_s            : std_logic_vector(7 downto 0);
    signal digit2_s            : std_logic_vector(7 downto 0);
    signal digit3_s            : std_logic_vector(7 downto 0);
    signal digit4_s            : std_logic_vector(7 downto 0);
    signal digit5_s            : std_logic_vector(7 downto 0);
    signal digit6_s            : std_logic_vector(7 downto 0);
    signal digit7_s            : std_logic_vector(7 downto 0);

    signal digit0_r            : std_logic_vector(7 downto 0);
    signal digit1_r            : std_logic_vector(7 downto 0);
    signal digit2_r            : std_logic_vector(7 downto 0);
    signal digit3_r            : std_logic_vector(7 downto 0);
    signal digit4_r            : std_logic_vector(7 downto 0);
    signal digit5_r            : std_logic_vector(7 downto 0);
    signal digit6_r            : std_logic_vector(7 downto 0);
    signal digit7_r            : std_logic_vector(7 downto 0);

    signal anode_s             : std_logic_vector(7 downto 0);
    signal cathode_s           : std_logic_vector(7 downto 0);
    signal anode_r             : std_logic_vector(7 downto 0);
    signal cathode_r           : std_logic_vector(7 downto 0);
begin
    u_soda_price_bcd: bin_bcd
    port map (
        clk   => clk             ,
        din   => soda_price_r    ,
        dout  => soda_price_bcd_s
    );
    u_deposit_amt_bcd: bin_bcd
    port map (
        clk   => clk              ,
        din   => deposit_amt_r    ,
        dout  => deposit_amt_bcd_s
    );

    u_digit0: decoder_bcd_7seg
    port map(
        invalid   => '0',
        din       => deposit_amt_bcd_s(3 downto 0),
        dout      => digit0_s(7 downto 1)
    );
    u_digit1: decoder_bcd_7seg
    port map(
        invalid   => '0',
        din       => deposit_amt_bcd_s(7 downto 4),
        dout      => digit1_s(7 downto 1)
    );
    u_digit2: decoder_bcd_7seg
    port map(
        invalid   => '0',
        din       => deposit_amt_bcd_s(11 downto 8),
        dout      => digit2_s(7 downto 1)
    );
    u_digit3: decoder_bcd_7seg
    port map(
        invalid   => '0',
        din       => deposit_amt_bcd_s(15 downto 12),
        dout      => digit3_s(7 downto 1)
    );

    u_digit4: decoder_bcd_7seg
    port map(
        invalid   => soda_reserved_r,
        din       => soda_price_bcd_s(3 downto 0),
        dout      => digit4_s(7 downto 1)
    );
    u_digit5: decoder_bcd_7seg
    port map(
        invalid   => soda_reserved_r,
        din       => soda_price_bcd_s(7 downto 4),
        dout      => digit5_s(7 downto 1)
    );
    u_digit6: decoder_bcd_7seg
    port map(
        invalid   => soda_reserved_r,
        din       => soda_price_bcd_s(11 downto 8),
        dout      => digit6_s(7 downto 1)
    );
    u_digit7: decoder_bcd_7seg
    port map(
        invalid   => soda_reserved_r,
        din       => soda_price_bcd_s(15 downto 12),
        dout      => digit7_s(7 downto 1)
    );
    
    -- Decimal point
    digit0_s(0) <= '1';
    digit1_s(0) <= '1';
    digit2_s(0) <= '0';
    digit3_s(0) <= '1';
    digit4_s(0) <= '1';
    digit5_s(0) <= '1';
    digit6_s(0) <= '0';
    digit7_s(0) <= '1';

    u_display_7seg: display_7seg
    port map(
        clk     => clk       ,
        rst     => rst       ,
        digit0  => digit0_r  ,
        digit1  => digit1_r  ,
        digit2  => digit2_r  ,
        digit3  => digit3_r  ,
        digit4  => digit4_r  ,
        digit5  => digit5_r  ,
        digit6  => digit6_r  ,
        digit7  => digit7_r  ,
        anode   => anode_s   ,
        cathode => cathode_s  
    );

    REG : process(clk)
    begin
        if rising_edge(clk) then
            soda_reserved_r <= soda_reserved_i;
            soda_price_r    <= soda_price_i   ;
            deposit_amt_r   <= deposit_amt_i  ;

            digit0_r <= digit0_s;
            digit1_r <= digit1_s;
            digit2_r <= digit2_s;
            digit3_r <= digit3_s;
            digit4_r <= digit4_s;
            digit5_r <= digit5_s;
            digit6_r <= digit6_s;
            digit7_r <= digit7_s;

            anode_r <= anode_s;
            cathode_r <= cathode_s;
        end if;
    end process;

    anode_o <= anode_r;
    cathode_o <= cathode_r;
end mixed;
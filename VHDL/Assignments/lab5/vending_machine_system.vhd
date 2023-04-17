-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- This is the complete Vending Machine System in a single file with all components.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_7seg is
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
end display_7seg;

architecture behavioral of display_7seg is
    -- FREQ = 100 MHz
    -- REFRESH RATE = (counter)/FREQ = (2^19)/100,000 = 5.24ms
    constant COUNTER_SZ : integer := 19;
    signal counter : std_logic_vector(COUNTER_SZ-1 downto 0);
begin

    cathode_anode: process(clk)
    begin
        if rising_edge(clk) then
            case counter(COUNTER_SZ-1 downto COUNTER_SZ-3) is
                when "000" =>
                    anode   <= "11111110";
                    cathode <= digit0;
                when "001" =>
                    anode   <= "11111101";
                    cathode <= digit1;
                when "010" =>
                    anode   <= "11111011";
                    cathode <= digit2;
                when "011" =>
                    anode   <= "11110111";
                    cathode <= digit3;
                when "100" =>
                    anode   <= "11101111";
                    cathode <= digit4;
                when "101" =>
                    anode   <= "11011111";
                    cathode <= digit5;
                when "110" =>
                    anode   <= "10111111";
                    cathode <= digit6;
                when "111" =>
                    anode   <= "01111111";
                    cathode <= digit7;
                when others =>
                    anode   <= (others => '1');
                    cathode <= (others => '1');
            end case;
        end if;
    end process;

    COUNTER_REG: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                counter <= (others => '0');
            else
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end process;

end behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_bcd is
    port (
        clk     : in  std_logic;
        din     : in  std_logic_vector(11 downto 0);
        dout    : out std_logic_vector(15 downto 0)
    );
end bin_bcd;

architecture behavioral of bin_bcd is
    type state is (LOAD, COMPUTE);
    signal current_state, next_state: state;

    signal counter      : unsigned(3 downto 0);
    signal counter_done : std_logic;

    signal data_check   : unsigned(27 downto 0);
    signal data         : unsigned(27 downto 0);
begin
    FSM_NEXT_STATE: process(current_state, counter_done)
    begin
        case current_state is
            when LOAD =>
                next_state <= COMPUTE;
            when COMPUTE =>
                if counter_done = '1' then
                    next_state <= LOAD;
                else
                    next_state <= COMPUTE;
                end if;
            when others =>
                next_state <= LOAD;
        end case;
    end process;

    FSM_CURRENT_STATE: process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    COUNTER_REG : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = LOAD then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    counter_done <= '1' when counter = x"B" else '0';

    -- Data
    data_check(11 downto 0)  <= data(11 downto 0);
    data_check(15 downto 12) <= data(15 downto 12)+3 when data(15 downto 12) > 4 else data(15 downto 12);
    data_check(19 downto 16) <= data(19 downto 16)+3 when data(19 downto 16) > 4 else data(19 downto 16);
    data_check(23 downto 20) <= data(23 downto 20)+3 when data(23 downto 20) > 4 else data(23 downto 20);
    data_check(27 downto 24) <= data(27 downto 24)+3 when data(27 downto 24) > 4 else data(27 downto 24);
    
    DATA_REG: process(clk)
    begin
        if rising_edge(clk) then
            case current_state is
                when COMPUTE =>
                    data <= shift_left(data_check, 1);
                when others =>
                    data(11 downto 0) <= unsigned(din);
                    data(27 downto 12) <= (others => '0');
            end case;
        end if;
    end process;


    OUTPUT_REG : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = LOAD then
                dout <= std_logic_vector(data(27 downto 12));
            end if;
        end if;
    end process;

end behavioral;


library ieee;
use ieee.std_logic_1164.all;

entity decoder_bcd_7seg is
    port (
        invalid : in  std_logic;
        din     : in  std_logic_vector(3 downto 0);
        dout    : out std_logic_vector(6 downto 0)
    );
end decoder_bcd_7seg;

architecture behavioral of decoder_bcd_7seg is
begin
    DECODE: process(invalid, din)
    begin
        if invalid = '1' then
            dout <= "1111110"; -- invalid
        else
            case(din) is
                when "0000" => dout <= "0000001"; --0
                when "0001" => dout <= "1001111"; --1
                when "0010" => dout <= "0010010"; --2
                when "0011" => dout <= "0000110"; --3
                when "0100" => dout <= "1001100"; --4
                when "0101" => dout <= "0100100"; --5
                when "0110" => dout <= "0100000"; --6
                when "0111" => dout <= "0001111"; --7
                when "1000" => dout <= "0000000"; --8
                when "1001" => dout <= "0000100"; --9
                when others => dout <= "1111110"; --invalid
            end case;
        end if;
    end process;
end behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity locking_system is
    port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        req_short_lock : in  std_logic;
        req_long_lock  : in  std_logic;
        lock           : out std_logic 
    );
end locking_system;

architecture behavioral of locking_system is
    type state is (IDLE, SHORT_LOCK, LONG_LOCK);
    signal current_state, next_state: state;

    signal counter: unsigned(27 downto 0);
    signal counter_short_done: std_logic;
    signal counter_long_done: std_logic;
begin

    FSM_NEXT_STATE: process(current_state, req_short_lock, req_long_lock, counter_short_done, counter_long_done)
    begin
        case current_state is
            when IDLE =>
                if req_short_lock = '1' then
                    next_state <= SHORT_LOCK;
                elsif req_long_lock = '1' then
                    next_state <= LONG_LOCK;
                else
                    next_state <= IDLE;
                end if;
            when SHORT_LOCK =>
                if req_long_lock = '1' then
                    next_state <= LONG_LOCK;
                elsif counter_short_done = '1' then
                    next_state <= IDLE;
                else
                    next_state <= SHORT_LOCK;
                end if;
            when LONG_LOCK =>
                if counter_long_done = '1' then
                    next_state <= IDLE;
                else
                    next_state <= LONG_LOCK;
                end if;
            when others =>
                next_state <= IDLE;
        end case;
    end process;

    FSM_CURRENT_STATE: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                current_state <= IDLE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    COUNTER_REG : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = IDLE then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    counter_short_done <= '1' when counter(15 downto 0) = x"ffff" else '0';
    counter_long_done <= '1' when counter = x"fffffff" else '0';

    lock <= '1' when (current_state /= IDLE) else '0';
end behavioral;


library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_cc is
    port (
        clk            : in  std_logic;
        rst_i          : in  std_logic;
        soda_sel_i     : in  std_logic_vector(3 downto 0);
        soda_req_i     : in  std_logic;
        cent_push_i    : in  std_logic;
        nickel_push_i  : in  std_logic;
        dime_push_i    : in  std_logic;
        quarter_push_i : in  std_logic;

        rst_o          : out std_logic;
        soda_sel_o     : out std_logic_vector(3 downto 0);
        soda_req_o     : out std_logic;
        cent_push_o    : out std_logic;
        nickel_push_o  : out std_logic;
        dime_push_o    : out std_logic;
        quarter_push_o : out std_logic 
    );
end vending_machine_cc;

architecture behavioral of vending_machine_cc is
    signal rst_r          : std_logic;
    signal soda_sel_r     : std_logic_vector(3 downto 0);
    signal soda_req_r     : std_logic;
    signal cent_push_r    : std_logic;
    signal nickel_push_r  : std_logic;
    signal dime_push_r    : std_logic;
    signal quarter_push_r : std_logic;
begin
    REG: process(clk)
    begin
        if rising_edge(clk) then
            rst_r          <= rst_i         ;
            soda_sel_r     <= soda_sel_i    ;
            soda_req_r     <= soda_req_i    ;
            cent_push_r    <= cent_push_i   ;
            nickel_push_r  <= nickel_push_i ;
            dime_push_r    <= dime_push_i   ;
            quarter_push_r <= quarter_push_i;

            rst_o          <= rst_r         ;
            soda_sel_o     <= soda_sel_r    ;
            soda_req_o     <= soda_req_r    ;
            cent_push_o    <= cent_push_r   ;
            nickel_push_o  <= nickel_push_r ;
            dime_push_o    <= dime_push_r   ;
            quarter_push_o <= quarter_push_r;
        end if;
    end process;
end behavioral;


library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_input is
    port (
        clk            : in  std_logic;

        lock_i         : in  std_logic;
        soda_sel_i     : in  std_logic_vector(3 downto 0);
        soda_req_i     : in  std_logic;
        cent_push_i    : in  std_logic;
        nickel_push_i  : in  std_logic;
        dime_push_i    : in  std_logic;
        quarter_push_i : in  std_logic;

        lock_req_o     : out std_logic;
        soda_sel_o     : out std_logic_vector(3 downto 0);
        soda_req_o     : out std_logic;
        coin_push_o    : out std_logic;
        coin_sel_o     : out std_logic_vector(1 downto 0) 
    );
end vending_machine_input;

architecture behavioral of vending_machine_input is
    signal button_lock_s       : std_logic;
    signal button_lock_pulse_s : std_logic;

    signal button_lock_r       : std_logic;
    signal lock_req_r          : std_logic;
    signal soda_sel_r          : std_logic_vector(3 downto 0);
    signal soda_req_r          : std_logic;
    signal coin_push_r         : std_logic;
    signal coin_sel_r          : std_logic_vector(1 downto 0);

    signal soda_sel_locked_r   : std_logic_vector(3 downto 0);
    signal soda_req_locked_r   : std_logic;
    signal coin_push_locked_r  : std_logic;
    signal coin_sel_locked_r   : std_logic_vector(1 downto 0);
begin
    button_lock_s <= soda_req_i or cent_push_i or nickel_push_i or dime_push_i or quarter_push_i;
    button_lock_pulse_s <= button_lock_s and not button_lock_r;

    INPUT_REG : process(clk)
    begin
        if rising_edge(clk) then
            button_lock_r <= button_lock_s;
            lock_req_r  <= button_lock_pulse_s;
            soda_sel_r  <= soda_sel_i;
            soda_req_r  <= soda_req_i;
            coin_push_r <= cent_push_i or nickel_push_i or dime_push_i or quarter_push_i;
            if cent_push_i = '1' then
                coin_sel_r <= "00";
            elsif nickel_push_i = '1' then
                coin_sel_r <= "01";
            elsif dime_push_i = '1' then
                coin_sel_r <= "10";
            else
                coin_sel_r <= "11";
            end if;
        end if;
    end process;

    PULSE_REG: process(clk)
    begin
        if rising_edge(clk) then
            if lock_req_r = '1' and lock_i = '0' then
                if coin_push_r = '1' then
                    coin_push_locked_r <= '1';
                    soda_req_locked_r  <= '0';
                elsif soda_req_r = '1' then
                    coin_push_locked_r <= '0';
                    soda_req_locked_r  <= '1';
                else
                    coin_push_locked_r <= '0';
                    soda_req_locked_r  <= '0';
                end if;
            else
                coin_push_locked_r <= '0';
                soda_req_locked_r  <= '0';
            end if;
        end if;
    end process;

    SEL_REG: process(clk)
    begin
        if rising_edge(clk) then
            if lock_i = '0' then
                soda_sel_locked_r <= soda_sel_r;
                coin_sel_locked_r <= coin_sel_r;
            end if;
        end if;
    end process;

    lock_req_o  <= lock_req_r         ;
    soda_sel_o  <= soda_sel_locked_r  ;
    soda_req_o  <= soda_req_locked_r  ;
    coin_push_o <= coin_push_locked_r ;
    coin_sel_o  <= coin_sel_locked_r  ;
end behavioral;


library ieee;
use ieee.std_logic_1164.all;

entity vending_machine_led is
    port (
        clk                : in  std_logic;

        coin_reject_i      : in  std_logic;
        soda_drop_i        : in  std_logic;
        error_amt_i        : in  std_logic;
        error_reserved_i   : in  std_logic;

        lock_req_o         : out std_logic;
        coin_reject_o      : out std_logic;
        soda_drop_o        : out std_logic;
        error_amt_o        : out std_logic;
        error_reserved_o   : out std_logic 
    );
end vending_machine_led;

architecture behavioral of vending_machine_led is
    signal coin_reject_r       : std_logic;
    signal soda_drop_r         : std_logic;
    signal error_amt_r         : std_logic;
    signal error_reserved_r    : std_logic;

    signal led_lock_s          : std_logic;
    signal led_lock_pulse_s    : std_logic;

    signal led_lock_r          : std_logic;
    signal lock_req_r          : std_logic;
begin
    led_lock_s <= coin_reject_r or soda_drop_r or error_amt_r or error_reserved_r;
    led_lock_pulse_s <= led_lock_s and not led_lock_r;

    REG : process(clk)
    begin
        if rising_edge(clk) then
            coin_reject_r    <= coin_reject_i   ;
            soda_drop_r      <= soda_drop_i     ;
            error_amt_r      <= error_amt_i     ;
            error_reserved_r <= error_reserved_i;

            led_lock_r <= led_lock_s;
            lock_req_r <= led_lock_pulse_s;
        end if;
    end process;

    lock_req_o       <= lock_req_r       ;
    coin_reject_o    <= coin_reject_r    ;
    soda_drop_o      <= soda_drop_r      ;
    error_amt_o      <= error_amt_r      ;
    error_reserved_o <= error_reserved_r ;

end behavioral;


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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine_system is
    port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        soda_sel       : in  std_logic_vector(3 downto 0);
        soda_req       : in  std_logic;
        soda_drop      : out std_logic;
        cent_push      : in  std_logic;
        nickel_push    : in  std_logic;
        dime_push      : in  std_logic;
        quarter_push   : in  std_logic;
        coin_reject    : out std_logic;
        error_amt      : out std_logic;
        error_reserved : out std_logic;
        anode          : out std_logic_vector(7 downto 0);
        CA             : out std_logic;
        CB             : out std_logic;
        CC             : out std_logic;
        CD             : out std_logic;
        CE             : out std_logic;
        CF             : out std_logic;
        CG             : out std_logic;
        DP             : out std_logic 
    );
end vending_machine_system;

architecture structural of vending_machine_system is
    component vending_machine_cc is
        port (
            clk            : in  std_logic;
            rst_i          : in  std_logic;
            soda_sel_i     : in  std_logic_vector(3 downto 0);
            soda_req_i     : in  std_logic;
            cent_push_i    : in  std_logic;
            nickel_push_i  : in  std_logic;
            dime_push_i    : in  std_logic;
            quarter_push_i : in  std_logic;
    
            rst_o          : out std_logic;
            soda_sel_o     : out std_logic_vector(3 downto 0);
            soda_req_o     : out std_logic;
            cent_push_o    : out std_logic;
            nickel_push_o  : out std_logic;
            dime_push_o    : out std_logic;
            quarter_push_o : out std_logic 
        );
    end component;

    component vending_machine_input is
        port (
            clk            : in  std_logic;
    
            lock_i         : in  std_logic;
            soda_sel_i     : in  std_logic_vector(3 downto 0);
            soda_req_i     : in  std_logic;
            cent_push_i    : in  std_logic;
            nickel_push_i  : in  std_logic;
            dime_push_i    : in  std_logic;
            quarter_push_i : in  std_logic;
    
            lock_req_o     : out std_logic;
            soda_sel_o     : out std_logic_vector(3 downto 0);
            soda_req_o     : out std_logic;
            coin_push_o    : out std_logic;
            coin_sel_o     : out std_logic_vector(1 downto 0) 
        );
    end component;

    component locking_system is
        port (
            clk            : in  std_logic;
            rst            : in  std_logic;
            req_short_lock : in  std_logic;
            req_long_lock  : in  std_logic;
            lock           : out std_logic 
        );
    end component;

    component vending_machine_subsystem is
        port(
            clk             : in  std_logic;
            rst             : in  std_logic;
            lock            : in  std_logic;
            soda_sel        : in  std_logic_vector(3 downto 0);
            soda_req        : in  std_logic;
            coin_push       : in  std_logic;
            coin_sel        : in  std_logic_vector(1 downto 0);
            coin_reject     : out std_logic;
            soda_reserved   : out std_logic;
            soda_price      : out std_logic_vector(11 downto 0);
            soda_drop       : out std_logic;
            deposit_amt     : out std_logic_vector(11 downto 0);
            error_amt       : out std_logic;
            error_reserved  : out std_logic
        );
    end component;
    
    component vending_machine_led is
        port (
            clk                : in  std_logic;

            coin_reject_i      : in  std_logic;
            soda_drop_i        : in  std_logic;
            error_amt_i        : in  std_logic;
            error_reserved_i   : in  std_logic;

            lock_req_o         : out std_logic;
            coin_reject_o      : out std_logic;
            soda_drop_o        : out std_logic;
            error_amt_o        : out std_logic;
            error_reserved_o   : out std_logic 
        );
    end component;

    component vending_machine_7seg is
        port (
            clk                : in  std_logic;
            rst                : in  std_logic;

            soda_reserved_i    : in  std_logic;
            soda_price_i       : in  std_logic_vector(11 downto 0);
            deposit_amt_i      : in  std_logic_vector(11 downto 0);

            anode_o            : out std_logic_vector(7 downto 0);
            cathode_o          : out std_logic_vector(7 downto 0) 
        );
    end component;

    signal rst_cc             : std_logic;
    signal soda_sel_cc        : std_logic_vector(3 downto 0);
    signal soda_req_cc        : std_logic;
    signal cent_push_cc       : std_logic;
    signal nickel_push_cc     : std_logic;
    signal dime_push_cc       : std_logic;
    signal quarter_push_cc    : std_logic;

    signal soda_sel_s         : std_logic_vector(3 downto 0);
    signal soda_req_s         : std_logic;
    signal coin_push_s        : std_logic;
    signal coin_sel_s         : std_logic_vector(1 downto 0);
    
    signal req_short_lock_s   : std_logic;
    signal req_long_lock_s    : std_logic;
    signal lock_s             : std_logic;

    signal coin_reject_s      : std_logic;
    signal soda_drop_s        : std_logic;
    signal error_amt_s        : std_logic;
    signal error_reserved_s   : std_logic;
    
    signal soda_reserved_s    : std_logic;
    signal soda_price_s       : std_logic_vector(11 downto 0);
    signal deposit_amt_s      : std_logic_vector(11 downto 0);

    signal cathode_s          : std_logic_vector(7 downto 0);
begin

    u_vending_machine_cc: vending_machine_cc
    port map (
        clk            => clk             ,
        rst_i          => rst             ,
        soda_sel_i     => soda_sel        ,
        soda_req_i     => soda_req        ,
        cent_push_i    => cent_push       ,
        nickel_push_i  => nickel_push     ,
        dime_push_i    => dime_push       ,
        quarter_push_i => quarter_push    ,

        rst_o          => rst_cc          ,
        soda_sel_o     => soda_sel_cc     ,
        soda_req_o     => soda_req_cc     ,
        cent_push_o    => cent_push_cc    ,
        nickel_push_o  => nickel_push_cc  ,
        dime_push_o    => dime_push_cc    ,
        quarter_push_o => quarter_push_cc  
    );

    u_vending_machine_input: vending_machine_input
    port map (
        clk             => clk             ,

        lock_i          => lock_s          ,
        soda_sel_i      => soda_sel_cc     ,
        soda_req_i      => soda_req_cc     ,
        cent_push_i     => cent_push_cc    ,
        nickel_push_i   => nickel_push_cc  ,
        dime_push_i     => dime_push_cc    ,
        quarter_push_i  => quarter_push_cc ,

        lock_req_o      => req_short_lock_s,
        soda_sel_o      => soda_sel_s      ,
        soda_req_o      => soda_req_s      ,
        coin_push_o     => coin_push_s     ,
        coin_sel_o      => coin_sel_s       
    );

    u_locking_system: locking_system
    port map (
        clk            => clk               ,
        rst            => rst_cc            ,
        req_short_lock => req_short_lock_s  ,
        req_long_lock  => req_long_lock_s   ,
        lock           => lock_s             
    );

    u_vending_machine_subsystem: vending_machine_subsystem
    port map (
        clk            => clk               ,
        rst            => rst_cc            ,
        lock           => lock_s            ,
        soda_sel       => soda_sel_s        ,
        soda_req       => soda_req_s        ,
        coin_push      => coin_push_s       ,
        coin_sel       => coin_sel_s        ,
        coin_reject    => coin_reject_s     ,
        soda_reserved  => soda_reserved_s   ,
        soda_price     => soda_price_s      ,
        soda_drop      => soda_drop_s       ,
        deposit_amt    => deposit_amt_s     ,
        error_amt      => error_amt_s       ,
        error_reserved => error_reserved_s   
    );

    u_vending_machine_led: vending_machine_led
    port map (
        clk               => clk               ,
        coin_reject_i     => coin_reject_s     ,
        soda_drop_i       => soda_drop_s       ,
        error_amt_i       => error_amt_s       ,
        error_reserved_i  => error_reserved_s  ,

        lock_req_o        => req_long_lock_s   ,
        coin_reject_o     => coin_reject       ,
        soda_drop_o       => soda_drop         ,
        error_amt_o       => error_amt         ,
        error_reserved_o  => error_reserved     
    );

    u_vending_machine_7seg: vending_machine_7seg
    port map (
        clk               => clk               ,
        rst               => rst_cc            ,
        soda_reserved_i   => soda_reserved_s   ,
        soda_price_i      => soda_price_s      ,
        deposit_amt_i     => deposit_amt_s     ,
        anode_o           => anode             ,
        cathode_o         => cathode_s          
    );

    CA <= cathode_s(7);
    CB <= cathode_s(6);
    CC <= cathode_s(5);
    CD <= cathode_s(4);
    CE <= cathode_s(3);
    CF <= cathode_s(2);
    CG <= cathode_s(1);
    DP <= cathode_s(0);

end structural;
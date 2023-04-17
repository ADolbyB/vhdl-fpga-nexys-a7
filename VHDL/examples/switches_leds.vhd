-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Simple example that uses 2 switches to control 2 LEDs

library ieee; -- Library declaration
use ieee.std_logic_1164.all; -- Use all definitions from steady state logic package

entity switches_leds is
    port (
        switch0 : in std_logic;
        switch1 : in std_logic;
        led0 : out std_logic;
        led1 : out std_logic
    );
end switches_leds;

architecture behavioral of switches_leds is
    
begin
    led0 <= switch0;
    led1 <= switch1; 
end behavioral;
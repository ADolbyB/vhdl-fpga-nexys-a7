-- Joel Brigida
-- CDA 4240C: Digital Design Lab
-- Solution for HW2: Clock syncronized Output Controller 

library IEEE;
use ieee.std_logic_1164.all;

Entity Start_Stop_Run is
    Port(
        CLOCK : in std_logic; -- Clock Input
        START : in std_logic; -- Start Signal
        STOP : in std_logic;  -- Stop Signal
        RUN : out std_logic   -- '0' = Don't Run, '1' = Run
    );
End Entity Start_Stop_Run;

Architecture dataflow of Start_Stop_Run is
    -- Declare an intermediate signal for output control
    -- Must be set to '0' otherwise output is initially "Undefined"
    signal RunTime : std_logic := '0';
begin
    process (CLOCK)
    begin -- note that Start = '1' and Stop = '1' will NOT toggle output
        if rising_edge(CLOCK) then
            if (START = '1') then
                RunTime <= '1';
            elsif (STOP = '1') then
                RunTime <= '0';
            end if;
        end if;
    end process;
    RUN <= RunTime;
end dataflow;
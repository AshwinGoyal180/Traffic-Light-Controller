-- 4 way traffic light control

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- port definition
-- clr: clears all outputs
-- mode: '0' - auto, '1' - manual
-- green, yellow, red: lights in 4 ways E-W-N-S order
-- zebraRed, zebraGreen: zebra crossing lights EW-NS order

entity controller is
    port(clr: in std_logic;
         mode: in std_logic;
         green: out std_logic_vector(3 downto 0);
         yellow: out std_logic_vector(3 downto 0);
         red: out std_logic_vector(3 downto 0);
         zebraRed: out std_logic(1 downto 0);
         zebraGreen: out std_logic(1 downto 0));
end controller;


architecture arch of controller is

    -- type state is range 0 to 11;   -- number of states
    -- signal presentState, nextState : state;
    signal state: integer range 0 to 11 := 0;
    signal timeout: std_logic := '0'; -- flag '1' if timeout in any state
    signal Tl, Ts: std_logic := '0';  -- signals to trigger timer function Tl - long time, Ts - short time

begin

    -- sequential circuit to determine present state
    seq: process (clr, mode, timeout)
    begin
        if mode = '0' then
            if clr = '1' then
                state <= 0;
            elsif rising_edge(timeout) then
                state <= state + 1;
            end if;

        -- manual mode is to be added
        end if;
    end process;

    -- combinational circuit which maps present state to correspongind lights
    comb: process (state)
    begin
        case state is
            when 0 =>
                -- EW green and Zebra NS GREEN, all others RED
                green(3 downto 2) <= "11"; red(3 downto 2) <= "00"; -- EW
                green(1 downto 0) <= "00"; red(1 downto 0) <= "11"; -- NS
                yellow(3 downto 0) <= "0000";

                zebraGreen(1) <= '0'; zebraRed(1) <= '1'; --EW
                zebraGreen(0) <= '1'; zebraRed(0) <= '0'; --NS

                -- start timer
                Tl <= '1';
                timeout <= timer();
            
            when 1 =>
                -- E - yellow, turn off green
                yellow(3) <= '1'; green(3) <= '0';

                -- start timer
                Ts <= '1';
                timeout <= timer();
            
            when 2 =>
                -- E-red, turn off yellow
                red(3) <= '1'; yellow(3) <= '0';
                --Zebra-NS red, turnoff green
                zebraRed(0) <= '1'; zebraGreen(0) <= '0';

                --start timer
                Tl <= 1;
                timeout <= timer();
            
            when 3 =>
                -- W-yellow, turn off green
                yellow(2) <= '1'; green(2) <= '0';

                --start timer
                Ts <= '1';
                timeout <= timer();

            when 4 =>
                -- W-red, turn off yellow
                red(2) <= '1'; yellow(2) <= '0';
                -- E-green, turn off red
                green(3) <= '1'; red(3) <= '0';

                --start timer
                Tl <= '1';
                timeout <= timer();
            
            when 5 =>
                -- E-yellow, turn off green
                yellow(3) <= '1'; green(3) <= '0';

                --start timer
                Ts <= '1';
                timeout <= timer();

            when 6 =>
                --E-red, turnoff yellow
                red(3) <= '1'; yellow(3) <= '0';
                --NS - green, turn off red
                green(1 downto 0) <= "11"; red(1 downto 0) <= "00";
                --Zebra-EW green, turn off red
                zebraGreen(1) <= '1'; zebraRed(1) <= '0';

                --start timer
                Tl <= '1';
                timeout <= timer();
            
            when 7 =>
                -- N-yellow, turnoff green
                yellow(1) <= '1'; green(1) <= '0';

                --start timer
                Ts <= '1';
                timeout <= timer();

            when 8 =>
                --N-red, turn off yellow
                red(1) <= '1'; yellow(1) <= '0';
                --Zebra EW- red, turnoff green
                zebraRed(1) <= '1'; zebraGreen(1) <= '0';

                --start timer
                Tl <= '1';
                timeout <= timer();

            when 9 =>
                --S-yellow, turnoff green
                yellow(0) <= '1'; green(0) <= '0';

                --start timer
                Ts <= '1';
                timeout <= timer();
            
            when 10 =>
                --S-red, turn off yellow
                red(0) <= '1'; yellow(0) <= '0';
                --N-green, turnoff red
                green(1) <= '1'; red(1) <= '1';

                --start timer
                Tl <= '1';
                timeout <= timer();

            when 11 =>
                --N-yellow, turn off green
                yellow(1) <= '1'; green(1) <= '0';

                --start timer
                Tl <= '1';
                timeout <= timer();      
                          
        end case;

    end process;

    -- timer function
    function timer() return std_logic is

    end function;

end arch ; -- arch


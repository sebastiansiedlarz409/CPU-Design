library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity io is
    generic(
        P: integer := 48;
        N: integer := 32;  --how many bits width address is
        M: integer := 8    --how many bits width element is
    );
    port(
        SCL: in std_logic;
        RST: in std_logic := '1';
        GPIO: in std_logic_vector(31 DOWNTO 0); --mode
        GPIO_OUT: in std_logic_vector(31 DOWNTO 0); --to set OUTPUT
        GPIO_IN: out std_logic_vector(31 DOWNTO 0); --to read INPUT
        PINS: inout std_logic_vector(22 DOWNTO 0)
    );
end entity io;

--map
--16 gpio
--0xF00 IN/OUT
--0xF04 VALUE/PULLUP/PULLDOWN

architecture Behavioral of io is

begin

--gpio
process(SCL)
begin

    if rising_edge(SCL) then
        for I in 0 to 22 loop

            if GPIO(I) = '0' then --OUT
                PINS(I) <= GPIO_OUT(I);
            else --IN
                GPIO_IN(I) <= PINS(I);
            end if;
    
        end loop;
    end if;

end process;

end architecture Behavioral;
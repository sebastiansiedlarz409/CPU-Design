library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram is
generic(
	N: integer := 32;  --how many bits width address is
	M: integer := 8;   --how many bits width one element is
	S: integer := 16#FFF# --ram size * M
);
port(
	SCL: in std_logic; 								--clock
	RST: in std_logic := '1'; 						--reset
	RAM_IN: in std_logic_vector(M-1 DOWNTO 0);
	RAM_OUT: out std_logic_vector(M-1 DOWNTO 0);
	RAM_ADDR: in std_logic_vector(N-1 DOWNTO 0);
	RAM_RW: in std_logic; 							--1 means read, 0 means write
	RAM_GPIO: out std_logic_vector(31 DOWNTO 0)		--GPIO mode, GPIO value
);
end entity ram;

architecture Behavioral of ram is

type RAM_ARRAY is array (0 to S) of std_logic_vector(M-1 downto 0); -- 0 to 0x1000-1
signal RAM: RAM_ARRAY;

begin

process(SCL)
begin

if rising_edge(SCL) then

	if RAM_RW = '0' then --write
		RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_IN;
	else
		RAM_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));
	end if;

	if RST='0' then
		RAM_OUT <= x"00";
	end if;

end if;

end process;

RAM_GPIO(31 DOWNTO 24) <= RAM(16#F00#);
RAM_GPIO(23 DOWNTO 16) <= RAM(16#F01#);
RAM_GPIO(15 DOWNTO 8) <= RAM(16#F02#);
RAM_GPIO(7 DOWNTO 0) <= RAM(16#F03#);

end architecture Behavioral;
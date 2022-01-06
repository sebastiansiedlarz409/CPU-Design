library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom is
generic(
	O: integer := 48;  --how many bits fetch during execution
	N: integer := 32;  --how many bits width address is
	M: integer := 8;   --how many bits width one element is
	S: integer := 4096 --rom size * M
);
port(
	SCL: in std_logic; 								--clock
	RST: in std_logic := '1'; 						--reset
	ROM_OUT: out std_logic_vector(O-1 DOWNTO 0);
	ROM_ADDR: in std_logic_vector(N-1 DOWNTO 0)
);
end entity rom;

architecture Behavioral of rom is

type ROM_ARRAY is array (0 to S-1) of std_logic_vector(M-1 downto 0); -- 0 to 0x1000-1
signal ROM: ROM_ARRAY := (x"AA", x"AB", x"AC", x"AD", x"AE", x"AF", others=> x"99");

begin

process(SCL)
begin

if rising_edge(SCL) then

	if RST='0' then
		ROM_OUT <= x"000000000000";
	else
		ROM_OUT(47 DOWNTO 40) <= ROM(to_integer(unsigned(ROM_ADDR)));
		ROM_OUT(39 DOWNTO 32) <= ROM(to_integer(unsigned(ROM_ADDR))+1);
		ROM_OUT(31 DOWNTO 24) <= ROM(to_integer(unsigned(ROM_ADDR))+2);
		ROM_OUT(23 DOWNTO 16) <= ROM(to_integer(unsigned(ROM_ADDR))+3);
		ROM_OUT(15 DOWNTO 8) <= ROM(to_integer(unsigned(ROM_ADDR))+4);
		ROM_OUT(7 DOWNTO 0) <= ROM(to_integer(unsigned(ROM_ADDR))+5);
	end if;

end if;

end process;

end architecture Behavioral;
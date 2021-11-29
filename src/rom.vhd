library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom is
generic(
	N: integer := 32;  --how many bits width address is
	M: integer := 8;   --how many bits width one element is
	S: integer := 4096 --rom size * M
);
port(
	SCL: in std_logic; 								--clock
	RST: in std_logic := '1'; 						--reset
	ROM_OUT: out std_logic_vector(M-1 DOWNTO 0);
	ROM_ADDR: in std_logic_vector(N-1 DOWNTO 0)
);
end entity rom;

architecture Behavioral of rom is

type ROM_ARRAY is array (0 to S-1) of std_logic_vector(M-1 downto 0); -- 0 to 0x1000-1
signal ROM: ROM_ARRAY := (x"AA", x"AB", others=> x"99");

begin

process(SCL)
begin

if rising_edge(SCL) then

	if RST='0' then
		ROM_OUT <= x"00";
	else
		ROM_OUT <= ROM(to_integer(unsigned(ROM_ADDR)));
	end if;

	if RST='0' then
		ROM_OUT <= x"00";
	end if;

end if;

end process;

end architecture Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
generic(
	N: integer := 32 --how many bits width register is
);
port(
	SCL: in std_logic; --clock
	REG_IN: in std_logic_vector(N-1 DOWNTO 0) := x"00000000";
	REG_OUT: out std_logic_vector(N-1 DOWNTO 0) := x"00000000" --default 0x00000000
);
end entity reg;


architecture Behavioral of reg is
begin

process(SCL)
begin
	--write to register
	if rising_edge(SCL) then
		REG_OUT <= REG_IN;
	end if;

end process;

end architecture Behavioral;

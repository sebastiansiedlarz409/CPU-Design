library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is
generic(
	N: integer := 32 --how many bits width
);
port(
	SCL: in std_logic; --clock
	RST: in std_logic --reset
);
end entity cpu;

architecture Behavioral of cpu is

--inner signals for registers
signal R0: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R1: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R2: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R3: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R4: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R5: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R6: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R7: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal R8: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal SP: std_logic_vector(N-1 DOWNTO 0) := x"00000000";
signal IP: std_logic_vector(N-1 DOWNTO 0) := x"00000000";

begin

process(SCL)
begin

--reset whole cpu	
if RST='0' then
	R0 <= x"00000000";
	R1 <= x"00000000";
	R2 <= x"00000000";
	R3 <= x"00000000";
	R4 <= x"00000000";
	R5 <= x"00000000";
	R6 <= x"00000000";
	R7 <= x"00000000";
	R8 <= x"00000000";
	SP <= x"00000000";
	IP <= x"00000000";
end if;

end process;

end architecture Behavioral;

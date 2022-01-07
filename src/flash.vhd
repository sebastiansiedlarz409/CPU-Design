library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FLASH is
generic(
	O: integer := 48;  --how many bits fetch during execution
	N: integer := 32;  --how many bits width address is
	M: integer := 8;   --how many bits width one element is
	S: integer := 4096 --FLASH size * M
);
port(
	SCL: in std_logic; 								--clock
	RST: in std_logic := '1'; 						--reset
	FLASH_OUT: out std_logic_vector(O-1 DOWNTO 0);
	FLASH_ADDR: in std_logic_vector(N-1 DOWNTO 0)
);
end entity FLASH;

architecture Behavioral of FLASH is

type FLASH_ARRAY is array (0 to S-1) of std_logic_vector(M-1 downto 0); -- 0 to 0x1000-1

--trash
--signal FLASH: FLASH_ARRAY := (x"AA", x"AB", x"AC", x"AD", x"AE", x"AF", others=> x"99");

--test program 1
--signal FLASH: FLASH_ARRAY := (x"B0", x"0F", x"00", x"00", x"00", x"05", --mov r0, 5
--							x"B0", x"1F", x"00", x"00", x"00", x"01", 	--mov r1, 1
--							x"A0",										--add r0, r1
--							others=> x"00");

--test program 2
--signal FLASH: FLASH_ARRAY := (x"B0", x"0F", x"00", x"00", x"00", x"0A", --mov r0, 10
--							x"B0", x"1F", x"00", x"00", x"00", x"03", 	--mov r1, 3
--							x"A6",										--div r0, r1
--							x"D0", x"2F",								--push r2    //push rest
--							x"B1", x"38",								--move r3, sp
--							x"E0", x"34",								--ldr r3, r4
--							others=> x"00");

--test program 3
--signal FLASH: FLASH_ARRAY := (x"B0", x"0F", x"00", x"00", x"00", x"0A", --mov r0, 10
--							x"B0", x"1F", x"00", x"00", x"00", x"05", 	--mov r1, 5
--							x"D0", x"0F",								--push r0
--							x"A2",										--sub r0, r1
--							x"F5", x"00", x"00",x"00",x"0C",			--jnz 0xC    //jump if not zero IP==0xC
--							x"B0", x"0F", x"00", x"00", x"F0", x"00",   --mov r0, 0xF000
--							x"B1", x"18",								--mov r1, sp //calc diff
--							x"A2",										--sub r0, r1
--							x"B0", x"1F", x"00", x"00", x"00", x"04",   --mov r1, 4 //count elements
--							x"A6", 										--div r0, r1
--							others=> x"00");

--hardware program 4
--just led on
signal FLASH: FLASH_ARRAY := (x"B0", x"0F", x"00", x"00", x"00", x"01", --mov r0, 5
							x"B0", x"1F", x"00", x"00", x"F0", x"00", 	--mov r1, 1
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							others=> x"00");

begin

FLASH_OUT(47 DOWNTO 40) <= FLASH(to_integer(unsigned(FLASH_ADDR)));
FLASH_OUT(39 DOWNTO 32) <= FLASH(to_integer(unsigned(FLASH_ADDR))+1);
FLASH_OUT(31 DOWNTO 24) <= FLASH(to_integer(unsigned(FLASH_ADDR))+2);
FLASH_OUT(23 DOWNTO 16) <= FLASH(to_integer(unsigned(FLASH_ADDR))+3);
FLASH_OUT(15 DOWNTO 8) <= FLASH(to_integer(unsigned(FLASH_ADDR))+4);
FLASH_OUT(7 DOWNTO 0) <= FLASH(to_integer(unsigned(FLASH_ADDR))+5);

end architecture Behavioral;
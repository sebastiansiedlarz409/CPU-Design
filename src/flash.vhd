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
--just led off
--signal FLASH: FLASH_ARRAY := (x"B0", x"0F", x"00", x"00", x"00", x"04", --mov r0, 0x0004
--							x"B0", x"1F", x"00", x"00", x"0F", x"04", 	--mov r1, 0x0F04
--							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
--							others=> x"00");

--7segments screen
--signal FLASH: FLASH_ARRAY := (x"B0", x"0F", x"00", x"00", x"16", x"DF", --mov r0, 0x16DF //digit 5
--							x"B0", x"1F", x"00", x"00", x"0F", x"04", 	--mov r1, 0x0F04
--							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
--							others=> x"00");

--7segments screen loop
--9 0x16FF
--8 0x17FF
--7 0x107F
--6 0x17DF
--5 0x16DF
--4 0x166F
--3 0x14FF
--2 0x15BF
--1 0x106F
--0 0xF3FF all 4
signal FLASH: FLASH_ARRAY := (x"B0", x"0F", x"00", x"00", x"16", x"FF", --mov r0, 0x16DF //digit 9
							x"B0", x"1F", x"00", x"00", x"0F", x"04", 	--mov r1, 0x0F04
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"17", x"FF",   --mov r0, 0x16DF //digit 8
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"10", x"7F",   --mov r0, 0x16DF //digit 7
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"17", x"DF",   --mov r0, 0x16DF //digit 6
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"16", x"DF",   --mov r0, 0x16DF //digit 5
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"16", x"6F",   --mov r0, 0x16DF //digit 4
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"14", x"FF",   --mov r0, 0x16DF //digit 3
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"15", x"BF",   --mov r0, 0x16DF //digit 2
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"10", x"6F",   --mov r0, 0x16DF //digit 1
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"B0", x"0F", x"00", x"00", x"F3", x"FF",   --mov r0, 0x16DF //digit 0
							x"E2", x"10",								--str r1, r0 //r1 address, r0 value
							x"DB", x"00", x"98", x"96", x"80",			--nop 10 000 000 //sleep 1s
							x"F1", x"00", x"00", x"00", x"00",			--jump to IP = 0
							others=> x"00");

begin

FLASH_OUT(47 DOWNTO 40) <= FLASH(to_integer(unsigned(FLASH_ADDR)));
FLASH_OUT(39 DOWNTO 32) <= FLASH(to_integer(unsigned(FLASH_ADDR))+1);
FLASH_OUT(31 DOWNTO 24) <= FLASH(to_integer(unsigned(FLASH_ADDR))+2);
FLASH_OUT(23 DOWNTO 16) <= FLASH(to_integer(unsigned(FLASH_ADDR))+3);
FLASH_OUT(15 DOWNTO 8) <= FLASH(to_integer(unsigned(FLASH_ADDR))+4);
FLASH_OUT(7 DOWNTO 0) <= FLASH(to_integer(unsigned(FLASH_ADDR))+5);

end architecture Behavioral;
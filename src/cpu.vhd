library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is
generic(
	N: integer := 32; 			--how many bits width
	M: integer := 8				--how many bits width element is
);
port(
	SCL: in std_logic; 			--clock
	RST: in std_logic := '1' 	--reset
);
end entity cpu;

architecture Behavioral of cpu is

--signals for ram
signal RAM_IN: std_logic_vector(M-1 DOWNTO 0);
signal RAM_OUT: std_logic_vector(M-1 DOWNTO 0);
signal RAM_ADDR: std_logic_vector(N-1 DOWNTO 0);
signal RAM_RW: std_logic;

--signal for alu
signal INS: std_logic_vector(47 DOWNTO 0);

--ALU
component alu is
    port(
        SCL: in std_logic; 								--clock
        RST: in std_logic := '1'; 						--reset
        --all registers
        R0: inout std_logic_vector(N-1 DOWNTO 0);
        R1: inout std_logic_vector(N-1 DOWNTO 0);
        R2: inout std_logic_vector(N-1 DOWNTO 0);
        R3: inout std_logic_vector(N-1 DOWNTO 0);
        R4: inout std_logic_vector(N-1 DOWNTO 0);
        R5: inout std_logic_vector(N-1 DOWNTO 0);
        R6: inout std_logic_vector(N-1 DOWNTO 0);
        R7: inout std_logic_vector(N-1 DOWNTO 0);
        SP: inout std_logic_vector(N-1 DOWNTO 0);
        IP: inout std_logic_vector(N-1 DOWNTO 0);
        STATUS: inout std_logic_vector(3 DOWNTO 0);
        --instruction
        INS: in std_logic_vector(47 DOWNTO 0);
        --ram
        RAM_IN: out std_logic_vector(M-1 DOWNTO 0);
        RAM_OUT: in std_logic_vector(M-1 DOWNTO 0);
        RAM_ADDR: out std_logic_vector(N-1 DOWNTO 0);
        RAM_RW: out std_logic
    );
end component alu;

--RAM
component ram is
port(
	SCL: in std_logic; 				--clock
	RST: in std_logic := '1'; 			--reset
	RAM_IN: in std_logic_vector(M-1 DOWNTO 0);
	RAM_OUT: out std_logic_vector(M-1 DOWNTO 0);
	RAM_ADDR: in std_logic_vector(N-1 DOWNTO 0);
	RAM_RW: in std_logic 				--1 means read, 0 means write
);
end component ram;
--RAM END

signal ROM_OUT: std_logic_vector(M-1 DOWNTO 0);
signal ROM_ADDR: std_logic_vector(N-1 DOWNTO 0);

--ROM
component rom is
port(
	SCL: in std_logic; 								--clock
	RST: in std_logic := '1'; 						--reset
	ROM_OUT: out std_logic_vector(M-1 DOWNTO 0);
	ROM_ADDR: in std_logic_vector(N-1 DOWNTO 0)
);
end component rom;
--ROM END

begin

--ALU MAP
ALU_C: alu port map(
	SCL => SCL,
	RST => RST,
	RAM_IN => RAM_IN,
	RAM_OUT => RAM_OUT,
	RAM_ADDR => RAM_ADDR,
	RAM_RW => RAM_RW,
	INS => INS
);
--ALU MAP

--RAM MAP
RAM_C: ram port map (
	SCL => SCL,
	RST => RST,
	RAM_IN => RAM_IN,
	RAM_OUT => RAM_OUT,
	RAM_ADDR => RAM_ADDR,
	RAM_RW => RAM_RW
);
--RAM MAP END

--ROM MAP
ROM_C: rom port map (
	SCL => SCL,
	RST => RST,
	ROM_OUT => ROM_OUT,
	ROM_ADDR => ROM_ADDR
);
--ROM MAP END

process(SCL)
begin

if rising_edge(SCL) then
	
	--reset whole cpu	
	if RST='0' then
		RAM_RW <= '1';
		RAM_ADDR <= x"00000000";
		RAM_IN <= x"00";
		ROM_ADDR <= x"00000000";
	end if;

end if;

end process;

end architecture Behavioral;

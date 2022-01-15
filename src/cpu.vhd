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
	RST: in std_logic := '1'; 	--reset
    PINS: inout std_logic_vector(22 DOWNTO 0)
);
end entity cpu;

architecture Behavioral of cpu is

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
        STATUS: inout std_logic_vector(1 DOWNTO 0);
        PINS: inout std_logic_vector(22 DOWNTO 0)
    );
end component alu;

begin

--ALU MAP
ALU_C: alu port map(
	SCL => SCL,
	RST => RST,
    PINS => PINS
);
--ALU MAP

process(SCL)
begin

	if rising_edge(SCL) then

	end if;

end process;

end architecture Behavioral;
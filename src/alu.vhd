library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    generic(
        P: integer := 48;
        N: integer := 32;  --how many bits width address is
        M: integer := 8    --how many bits width element is
    );
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
        SP: inout std_logic_vector(N-1 DOWNTO 0) := x"00000F00";
        IP: inout std_logic_vector(N-1 DOWNTO 0) := x"00000000";
        STATUS: inout std_logic_vector(1 DOWNTO 0);
        PINS: inout std_logic_vector(22 DOWNTO 0)
    );
end entity alu;

architecture Behavioral of alu is

signal cycles: integer := 0;
signal rcycles: integer := 0;

alias Z: std_logic is STATUS(0);
alias S: std_logic is STATUS(1);
--alias C: std_logic is STATUS(2);
--alias O: std_logic is STATUS(3);

signal FLASH_OUT: std_logic_vector(P-1 DOWNTO 0);

--instruction
signal INS: std_logic_vector(P-1 DOWNTO 0);

--ROM
component FLASH is
port(
	SCL: in std_logic; 								--clock
	RST: in std_logic := '1'; 						--reset
	FLASH_OUT: out std_logic_vector(P-1 DOWNTO 0);
	FLASH_ADDR: in std_logic_vector(N-1 DOWNTO 0)
);
end component FLASH;
--ROM END

--signals for ram
signal RAM_IN: std_logic_vector(M-1 DOWNTO 0);
signal RAM_OUT: std_logic_vector(M-1 DOWNTO 0);
signal RAM_ADDR: std_logic_vector(N-1 DOWNTO 0);
signal RAM_RW: std_logic;

--RAM
component ram is
    port(
        SCL: in std_logic; 				            --clock
        RST: in std_logic := '1'; 		            --reset
        RAM_IN: in std_logic_vector(M-1 DOWNTO 0);
        RAM_OUT: out std_logic_vector(M-1 DOWNTO 0);
        RAM_ADDR: in std_logic_vector(N-1 DOWNTO 0);
        RAM_RW: in std_logic; 			            --1 means read, 0 means write
        RAM_GPIO: out std_logic_vector(31 DOWNTO 0);
        RAM_GPIO_IN: in std_logic_vector(31 DOWNTO 0);		--GPIO INPUT
        RAM_GPIO_OUT: out std_logic_vector(31 DOWNTO 0)		--GPIO OUTPUT
    );
end component ram;
--RAM END

--IO
component io is
    port(
        SCL: in std_logic;
        RST: in std_logic := '1';
        GPIO: in std_logic_vector(31 DOWNTO 0); --mode
        GPIO_OUT: in std_logic_vector(31 DOWNTO 0); --to set OUTPUT
        GPIO_IN: out std_logic_vector(31 DOWNTO 0); --to read INPUT
        PINS: inout std_logic_vector(22 DOWNTO 0)
    );
end component io;
--IO END

signal GPIO: std_logic_vector(31 DOWNTO 0);
signal GPIO_IN: std_logic_vector(31 DOWNTO 0);
signal GPIO_OUT: std_logic_vector(31 DOWNTO 0);

begin

--FLASH MAP
FLASH_C: FLASH port map (
	SCL => SCL,
	RST => RST,
	FLASH_OUT => FLASH_OUT,
	FLASH_ADDR => IP
);
--FLASH MAP END

--RAM MAP
RAM_C: ram port map (
	SCL => SCL,
	RST => RST,
	RAM_IN => RAM_IN,
	RAM_OUT => RAM_OUT,
	RAM_ADDR => RAM_ADDR,
	RAM_RW => RAM_RW,
    RAM_GPIO => GPIO,
    RAM_GPIO_IN => GPIO_IN,
    RAM_GPIO_OUT => GPIO_OUT
);
--RAM MAP END

--IO MAP
IO_C: io port map(
    SCL => SCL,
    RST => RST,
    GPIO_OUT => GPIO_OUT,
    GPIO_IN => GPIO_IN,
    GPIO => GPIO,
    PINS => PINS
);
--IO MAP END

process(SCL)
begin

    if rising_edge(SCL) then

        if RST='0' then
            RAM_RW <= '1';
            RAM_ADDR <= x"00000000";
            RAM_IN <= x"00";
            --FLASH_ADDR <= x"00000000";
            INS <= x"000000000000";
            R0 <= x"00000000";
            R1 <= x"00000000";
            R2 <= x"00000000";
            R3 <= x"00000000";
            R4 <= x"00000000";
            R5 <= x"00000000";
            R6 <= x"00000000";
            R7 <= x"00000000";
            SP <= x"0000F000";
            IP <= x"00000000";
            STATUS <= b"00";
        end if;

        case INS(47 DOWNTO 40) is

            --mov rX, imm32
            when x"B0" =>
                case INS(39 DOWNTO 36) is
                when x"0" =>
                if cycles < 4 then
                    r0(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"1" =>
                if cycles < 4 then
                    r1(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"2" =>
                if cycles < 4 then
                    r2(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"3" =>
                if cycles < 4 then
                    r3(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"4" =>
                if cycles < 4 then
                    r4(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"5" =>
                if cycles < 4 then
                    r5(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"6" =>
                if cycles < 4 then
                    r6(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"7" =>
                if cycles < 4 then
                    r7(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"8" =>
                if cycles < 4 then
                    sp(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when x"9" =>
                if cycles < 4 then
                    ip(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(31-(cycles*8) DOWNTO 24-(cycles*8));
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(6,32));
                end if;
                when others =>
                end case;

            --mov rX, rX //32bits registers
            when x"B1" =>
                case INS(39 DOWNTO 32) is
                    when x"00" =>
                        r0 <= r0;
                    when x"01" =>
                        r0 <= r1;
                    when x"02" =>
                        r0 <= r2;
                    when x"03" =>
                        r0 <= r3;
                    when x"04" =>
                        r0 <= r4;
                    when x"05" =>
                        r0 <= r5;
                    when x"06" =>
                        r0 <= r6;
                    when x"07" =>
                        r0 <= r7;
                    when x"08" =>
                        r0 <= sp;
                    when x"09" =>
                        r0 <= ip;

                    when x"10" =>
                        r1 <= r0;
                    when x"11" =>
                        r1 <= r1;
                    when x"12" =>
                        r1 <= r2;
                    when x"13" =>
                        r1 <= r3;
                    when x"14" =>
                        r1 <= r4;
                    when x"15" =>
                        r1 <= r5;
                    when x"16" =>
                        r1 <= r6;
                    when x"17" =>
                        r1 <= r7;
                    when x"18" =>
                        r1 <= sp;
                    when x"19" =>
                        r1 <= ip;
                        
                    when x"20" =>
                        r2 <= r0;
                    when x"21" =>
                        r2 <= r1;
                    when x"22" =>
                        r2 <= r2;
                    when x"23" =>
                        r2 <= r3;
                    when x"24" =>
                        r2 <= r4;
                    when x"25" =>
                        r2 <= r5;
                    when x"26" =>
                        r2 <= r6;
                    when x"27" =>
                        r2 <= r7;
                    when x"28" =>
                        r2 <= sp;
                    when x"29" =>
                        r2 <= ip;

                    when x"30" =>
                        r3 <= r0;
                    when x"31" =>
                        r3 <= r1;
                    when x"32" =>
                        r3 <= r2;
                    when x"33" =>
                        r3 <= r3;
                    when x"34" =>
                        r3 <= r4;
                    when x"35" =>
                        r3 <= r5;
                    when x"36" =>
                        r3 <= r6;
                    when x"37" =>
                        r3 <= r7;
                    when x"38" =>
                        r3 <= sp;
                    when x"39" =>
                        r3 <= ip;

                    when x"40" =>
                        r4 <= r0;
                    when x"41" =>
                        r4 <= r1;
                    when x"42" =>
                        r4 <= r2;
                    when x"43" =>
                        r4 <= r3;
                    when x"44" =>
                        r4 <= r4;
                    when x"45" =>
                        r4 <= r5;
                    when x"46" =>
                        r4 <= r6;
                    when x"47" =>
                        r4 <= r7;
                    when x"48" =>
                        r4 <= sp;
                    when x"49" =>
                        r4 <= ip;
                        
                    when x"50" =>
                        r5 <= r0;
                    when x"51" =>
                        r5 <= r1;
                    when x"52" =>
                        r5 <= r2;
                    when x"53" =>
                        r5 <= r3;
                    when x"54" =>
                        r5 <= r4;
                    when x"55" =>
                        r5 <= r5;
                    when x"56" =>
                        r5 <= r6;
                    when x"57" =>
                        r5 <= r7;
                    when x"58" =>
                        r5 <= sp;
                    when x"59" =>
                        r5 <= ip;

                    when x"60" =>
                        r6 <= r0;
                    when x"61" =>
                        r6 <= r1;
                    when x"62" =>
                        r6 <= r2;
                    when x"63" =>
                        r6 <= r3;
                    when x"64" =>
                        r6 <= r4;
                    when x"65" =>
                        r6 <= r5;
                    when x"66" =>
                        r6 <= r6;
                    when x"67" =>
                        r6 <= r7;
                    when x"68" =>
                        r6 <= sp;
                    when x"69" =>
                        r6 <= ip;
                        
                    when x"70" =>
                        r7 <= r0;
                    when x"71" =>
                        r7 <= r1;
                    when x"72" =>
                        r7 <= r2;
                    when x"73" =>
                        r7 <= r3;
                    when x"74" =>
                        r7 <= r4;
                    when x"75" =>
                        r7 <= r5;
                    when x"76" =>
                        r7 <= r6;
                    when x"77" =>
                        r7 <= r7;
                    when x"78" =>
                        r7 <= sp;
                    when x"79" =>
                        r7 <= ip;

                    when x"80" =>
                        sp <= r0;
                    when x"81" =>
                        sp <= r1;
                    when x"82" =>
                        sp <= r2;
                    when x"83" =>
                        sp <= r3;
                    when x"84" =>
                        sp <= r4;
                    when x"85" =>
                        sp <= r5;
                    when x"86" =>
                        sp <= r6;
                    when x"87" =>
                        sp <= r7;
                    when x"88" =>
                        sp <= sp;
                    when x"89" =>
                        sp <= ip;
                    
                    when x"90" =>
                        ip <= r0;
                    when x"91" =>
                        ip <= r1;
                    when x"92" =>
                        ip <= r2;
                    when x"93" =>
                        ip <= r3;
                    when x"94" =>
                        ip <= r4;
                    when x"95" =>
                        ip <= r5;
                    when x"96" =>
                        ip <= r6;
                    when x"97" =>
                        ip <= r7;
                    when x"98" =>
                        ip <= sp;
                    when x"99" =>
                        ip <= ip;

                    when others =>

                end case;

                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
            
            --arithmetic
            when x"A0" =>
                r0 <= std_logic_vector(unsigned(r0) + unsigned(r1));
                if std_logic_vector(unsigned(r0) + unsigned(r1)) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if (( std_logic_vector(unsigned(r0) + unsigned(r1)) ) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));

            when x"A2" =>
                r0 <= std_logic_vector(unsigned(r0) - unsigned(r1));
                if std_logic_vector(unsigned(r0) - unsigned(r1)) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if (( std_logic_vector(unsigned(r0) - unsigned(r1)) ) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
            when x"A4" =>
                --r0 <= std_logic_vector(unsigned(r0) * unsigned(r1))(31 DOWNTO 0);
                --if std_logic_vector(unsigned(r0) * unsigned(r1))(31 DOWNTO 0) = x"00000000" then
                --    Z <= '1';
                --else
                --    Z <= '0';
                --end if;
                --if (( std_logic_vector(unsigned(r0) * unsigned(r1)) ) and x"80000000") = x"80000000" then
                --    S <= '1';
                --else
                --    S <= '0';
                --end if;
                --increment IP
                --IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
            when x"A6" =>
                --r0 <= std_logic_vector(unsigned(r0) / unsigned(r1));
                --r2 <= std_logic_vector(unsigned(r0) mod unsigned(r1));
                --if std_logic_vector(unsigned(r0) + unsigned(r1)) = x"00000000" then
                --    Z <= '1';
                --else
                --    Z <= '0';
                --end if;
                --if (( std_logic_vector(unsigned(r0) + unsigned(r1)) ) and x"80000000") = x"80000000" then
                --    S <= '1';
                --else
                --    S <= '0';
                --end if;
                --increment IP
                --IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
                        
            when x"A8" =>
                r0 <= r0 and r1;
                if (r0 and r1) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if (( r0 and r1 ) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
            when x"AA" =>
                r0 <= r0 or r1;
                if (r0 or r1) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if (( r0 or r1 ) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
            when x"AC" =>
                r0 <= r0 xor r1;
                if (r0 xor r1) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if (( r0 xor r1 ) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
            when x"AE" =>
                r0 <= not r0;
                if (not r0) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if (( not r0 ) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));

            --shifts unsigned
            when x"C0" =>
                r0 <= std_logic_vector(
                    shift_left(
                        unsigned(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                );
                if std_logic_vector(
                    shift_left(
                        unsigned(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                ) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if ((std_logic_vector(
                    shift_left(
                        unsigned(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                )) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
            when x"C1" =>
                r0 <= std_logic_vector(
                    shift_right(
                        unsigned(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                );
                if std_logic_vector(
                    shift_right(
                        unsigned(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                ) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if ((std_logic_vector(
                    shift_right(
                        unsigned(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                )) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));

            --shifts signed
            when x"C2" =>
                r0 <= std_logic_vector(
                    shift_left(
                        signed(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                );
                if std_logic_vector(
                    shift_left(
                        signed(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                ) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if ((std_logic_vector(
                    shift_left(
                        signed(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                )) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));
                
            when x"C3" =>
                r0 <= std_logic_vector(
                    shift_right(
                        signed(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                );
                if std_logic_vector(
                    shift_right(
                        signed(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                ) = x"00000000" then
                    Z <= '1';
                else
                    Z <= '0';
                end if;
                if ((std_logic_vector(
                    shift_right(
                        signed(
                            r0
                        ),
                        to_integer(unsigned(r1))
                    )
                )) and x"80000000") = x"80000000" then
                    S <= '1';
                else
                    S <= '0';
                end if;
                --increment IP
                IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));

            --rotate unsigned
            --when x"C4" =>        
                --r0 <= r0(31-to_integer(unsigned(r1)) DOWNTO 0) & r0(31 DOWNTO 31-to_integer(unsigned(r1))+1);
                --if r0(31-to_integer(unsigned(r1)) DOWNTO 0) & r0(31 DOWNTO 31-to_integer(unsigned(r1))+1) = x"00000000" then
                --    Z <= '1';
                --else
                --    Z <= '0';
                --end if;
                --increment IP
                --IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));

            --when x"C5" =>
                --r0 <= r0(0+to_integer(unsigned(r1))-1 DOWNTO 0) & r0(31 DOWNTO 0+to_integer(unsigned(r1)));
                --if r0(0+to_integer(unsigned(r1))-1 DOWNTO 0) & r0(31 DOWNTO 0+to_integer(unsigned(r1))) = x"00000000" then
                --    Z <= '1';
                --else
                --    Z <= '0';
                --end if;
                --increment IP
                --IP <= std_logic_vector(unsigned(ip) + to_unsigned(1,32));

            --stack push
            when x"D0" =>
                if cycles < 4 then
                    RAM_RW <= '0';
                    RAM_ADDR <= std_logic_vector(unsigned(sp) - to_unsigned(cycles+1,32));
                    case INS(39 DOWNTO 32) is
                        when x"0F" =>
                        RAM_IN <= R0(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"1F" =>
                        RAM_IN <= R1(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"2F" =>
                        RAM_IN <= R2(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"3F" =>
                        RAM_IN <= R3(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"4F" =>
                        RAM_IN <= R4(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"5F" =>
                        RAM_IN <= R5(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"6F" =>
                        RAM_IN <= R6(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"7F" =>
                        RAM_IN <= R7(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"8F" =>
                        RAM_IN <= SP(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when x"9F" =>
                        RAM_IN <= IP(7+(cycles*8) DOWNTO 0+(cycles*8));
                        when others =>
                    end case;
                    cycles <= cycles + 1;
                else
                    --decrement stack
                    SP <= std_logic_vector(to_unsigned(to_integer(unsigned(SP)) - 4,32));
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;
            
            --stack pop
            when x"D2" =>
                if cycles < 2 then
                    RAM_RW <= '1';
                    RAM_ADDR <= std_logic_vector(unsigned(sp) + to_unsigned(cycles,32));
                    cycles <= cycles + 1;
                elsif cycles < 6 then
                    RAM_ADDR <= std_logic_vector(unsigned(sp) + to_unsigned(cycles,32));
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        R0(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"1" =>
                        R1(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"2" =>
                        R2(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"3" =>
                        R3(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"4" =>
                        R4(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"5" =>
                        R5(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"6" =>
                        R6(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"7" =>
                        R7(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"8" =>
                        SP(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"9" =>
                        IP(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when others =>
                    end case;
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment stac
                    SP <= std_logic_vector(to_unsigned(to_integer(unsigned(SP)) + 4,32));
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;
            
            when x"E0" => --ldr 32
                if cycles < 2 then
                    RAM_RW <= '1';
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) + cycles,32));
                        when x"1" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r1)) + cycles,32));
                        when x"2" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r2)) + cycles,32));
                        when x"3" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r3)) + cycles,32));
                        when x"4" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r4)) + cycles,32));
                        when x"5" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r5)) + cycles,32));
                        when x"6" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r6)) + cycles,32));
                        when x"7" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r7)) + cycles,32));
                        when x"8" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(sp)) + cycles,32));
                        when x"9" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(ip)) + cycles,32));
                        when others =>
                    end case;
                    cycles <= cycles + 1;
                elsif cycles < 6 then
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) + cycles,32));
                        when x"1" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r1)) + cycles,32));
                        when x"2" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r2)) + cycles,32));
                        when x"3" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r3)) + cycles,32));
                        when x"4" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r4)) + cycles,32));
                        when x"5" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r5)) + cycles,32));
                        when x"6" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r6)) + cycles,32));
                        when x"7" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r7)) + cycles,32));
                        when x"8" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(sp)) + cycles,32));
                        when x"9" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(ip)) + cycles,32));
                        when others =>
                    end case;
                    case INS(35 DOWNTO 32) is
                        when x"0" =>
                        R0(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"1" =>
                        R1(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"2" =>
                        R2(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"3" =>
                        R3(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"4" =>
                        R4(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"5" =>
                        R5(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"6" =>
                        R6(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"7" =>
                        R7(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"8" =>
                        SP(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when x"9" =>
                        IP(31-((cycles-2)*8) DOWNTO 24-((cycles-2)*8)) <= RAM_OUT;
                        when others =>
                    end case;
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;

            when x"E2" => --str 32
                if cycles < 4 then
                    RAM_RW <= '0';
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) + cycles,32));
                        when x"1" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r1)) + cycles,32));
                        when x"2" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r2)) + cycles,32));
                        when x"3" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r3)) + cycles,32));
                        when x"4" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r4)) + cycles,32));
                        when x"5" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r5)) + cycles,32));
                        when x"6" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r6)) + cycles,32));
                        when x"7" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(r7)) + cycles,32));
                        when x"8" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(sp)) + cycles,32));
                        when x"9" =>
                        RAM_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(ip)) + cycles,32));
                        when others =>
                    end case;
                    case INS(35 DOWNTO 32) is
                        when x"0" =>
                        RAM_IN <= R0(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"1" =>
                        RAM_IN <= R1(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"2" =>
                        RAM_IN <= R2(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"3" =>
                        RAM_IN <= R3(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"4" =>
                        RAM_IN <= R4(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"5" =>
                        RAM_IN <= R5(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"6" =>
                        RAM_IN <= R6(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"7" =>
                        RAM_IN <= R7(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"8" =>
                        RAM_IN <= SP(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when x"9" =>
                        RAM_IN <= IP(31-(cycles*8) DOWNTO 24-(cycles*8));
                        when others =>
                    end case;
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;

            --jmp
            when x"F0" =>
                case INS(39 DOWNTO 36) is
                    when x"0" =>
                    IP <= r0;
                    when x"1" =>
                    IP <= r1;
                    when x"2" =>
                    IP <= r2;
                    when x"3" =>
                    IP <= r3;
                    when x"4" =>
                    IP <= r4;
                    when x"5" =>
                    IP <= r5;
                    when x"6" =>
                    IP <= r6;
                    when x"7" =>
                    IP <= r7;
                    when x"8" =>
                    IP <= SP;
                    when x"9" =>
                    IP <= IP;
                    when others =>
                end case;
            
            --jmp imm32
            when x"F1" =>
                if cycles < 4 then
                        IP(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(39-(cycles*8) DOWNTO 32-(cycles*8));                        
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                end if;

            --nop rX
            when x"DA" =>
                case INS(39 DOWNTO 36) is
                    when x"0" =>
                    if cycles < to_integer(unsigned(r0)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"1" =>
                    if cycles < to_integer(unsigned(r1)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"2" =>
                    if cycles < to_integer(unsigned(r2)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"3" =>
                    if cycles < to_integer(unsigned(r3)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"4" =>
                    if cycles < to_integer(unsigned(r4)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"5" =>
                    if cycles < to_integer(unsigned(r5)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"6" =>
                    if cycles < to_integer(unsigned(r6)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"7" =>
                    if cycles < to_integer(unsigned(r7)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"8" =>
                    if cycles < to_integer(unsigned(sp)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when x"9" =>
                    if cycles < to_integer(unsigned(ip)) then
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                        --increment IP
                        IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                    end if;
                    when others =>
                end case;

            -- nop imm32
            when x"DB" =>
                if cycles < to_integer(unsigned(INS(39 DOWNTO 8))) then
                    cycles <= cycles + 1;
                else
                    cycles <= 0;
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(5,32));
                end if;

            --jz rX
            when x"F2" =>
                if Z = '1' then    
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        IP <= r0;
                        when x"1" =>
                        IP <= r1;
                        when x"2" =>
                        IP <= r2;
                        when x"3" =>
                        IP <= r3;
                        when x"4" =>
                        IP <= r4;
                        when x"5" =>
                        IP <= r5;
                        when x"6" =>
                        IP <= r6;
                        when x"7" =>
                        IP <= r7;
                        when x"8" =>
                        IP <= SP;
                        when x"9" =>
                        IP <= IP;
                        when others =>
                    end case;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;

            --jnz rX
            when x"F3" =>
                if Z = '0' then    
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        IP <= r0;
                        when x"1" =>
                        IP <= r1;
                        when x"2" =>
                        IP <= r2;
                        when x"3" =>
                        IP <= r3;
                        when x"4" =>
                        IP <= r4;
                        when x"5" =>
                        IP <= r5;
                        when x"6" =>
                        IP <= r6;
                        when x"7" =>
                        IP <= r7;
                        when x"8" =>
                        IP <= SP;
                        when x"9" =>
                        IP <= IP;
                        when others =>
                    end case;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;
            
            --jz imm32
            when x"F4" =>
                if Z = '1' then
                    if cycles < 4 then
                            IP(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(39-(cycles*8) DOWNTO 32-(cycles*8));                        
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                    end if;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(5,32));
                end if;

            --jnz imm32
            when x"F5" =>
                if Z = '0' then
                    if cycles < 4 then
                            IP(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(39-(cycles*8) DOWNTO 32-(cycles*8));                        
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                    end if;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(5,32));
                end if;

            --js rX
            when x"F6" =>
                if S = '1' then    
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        IP <= r0;
                        when x"1" =>
                        IP <= r1;
                        when x"2" =>
                        IP <= r2;
                        when x"3" =>
                        IP <= r3;
                        when x"4" =>
                        IP <= r4;
                        when x"5" =>
                        IP <= r5;
                        when x"6" =>
                        IP <= r6;
                        when x"7" =>
                        IP <= r7;
                        when x"8" =>
                        IP <= SP;
                        when x"9" =>
                        IP <= IP;
                        when others =>
                    end case;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;

            --jns rX
            when x"F7" =>
                if S = '0' then    
                    case INS(39 DOWNTO 36) is
                        when x"0" =>
                        IP <= r0;
                        when x"1" =>
                        IP <= r1;
                        when x"2" =>
                        IP <= r2;
                        when x"3" =>
                        IP <= r3;
                        when x"4" =>
                        IP <= r4;
                        when x"5" =>
                        IP <= r5;
                        when x"6" =>
                        IP <= r6;
                        when x"7" =>
                        IP <= r7;
                        when x"8" =>
                        IP <= SP;
                        when x"9" =>
                        IP <= IP;
                        when others =>
                    end case;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(2,32));
                end if;

            --js imm32
            when x"F8" =>
                if S = '1' then
                    if cycles < 4 then
                            IP(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(39-(cycles*8) DOWNTO 32-(cycles*8));                        
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                    end if;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(5,32));
                end if;

            --jns imm32
            when x"F9" =>
                if S = '0' then
                    if cycles < 4 then
                            IP(31-(cycles*8) DOWNTO 24-(cycles*8)) <= INS(39-(cycles*8) DOWNTO 32-(cycles*8));                        
                        cycles <= cycles + 1;
                    else
                        cycles <= 0;
                    end if;
                else
                    --increment IP
                    IP <= std_logic_vector(unsigned(ip) + to_unsigned(5,32));
                end if;
            
            when others =>

        end case;

    end if;

    if cycles = 0 then
        INS <= FLASH_OUT;
    end if;

end process;

end architecture Behavioral;
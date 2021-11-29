library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    generic(
        N: integer := 32;  --how many bits width address is
        M: integer := 8   --how many bits width element is
    );
    port(
        SCL: in std_logic; 								--clock
        RST: in std_logic := '1'; 						--reset
        --all registers
        R0: inout std_logic_vector(N-1 DOWNTO 0);
        R0d: inout std_logic_vector(N/2-1 DOWNTO 0);
        R1: inout std_logic_vector(N-1 DOWNTO 0);
        R1d: inout std_logic_vector(N/2-1 DOWNTO 0);
        R2: inout std_logic_vector(N-1 DOWNTO 0);
        R2d: inout std_logic_vector(N/2-1 DOWNTO 0);
        R3: inout std_logic_vector(N-1 DOWNTO 0);
        R3d: inout std_logic_vector(N/2-1 DOWNTO 0);
        R4: inout std_logic_vector(N-1 DOWNTO 0);
        R5: inout std_logic_vector(N-1 DOWNTO 0);
        R6: inout std_logic_vector(N-1 DOWNTO 0);
        R7: inout std_logic_vector(N-1 DOWNTO 0);
        R8: inout std_logic_vector(N-1 DOWNTO 0);
        R9: inout std_logic_vector(N-1 DOWNTO 0);
        R10: inout std_logic_vector(N-1 DOWNTO 0);
        R11: inout std_logic_vector(N-1 DOWNTO 0);
        R12: inout std_logic_vector(N-1 DOWNTO 0);
        R13: inout std_logic_vector(N-1 DOWNTO 0);
        R14: inout std_logic_vector(N-1 DOWNTO 0);
        SP: inout std_logic_vector(N-1 DOWNTO 0);
        IP: inout std_logic_vector(N-1 DOWNTO 0);
        --instruction
        INS: in std_logic_vector(47 DOWNTO 0)
    );
end entity alu;

architecture Behavioral of alu is

begin

process(SCL)
begin

    if rising_edge(SCL) then

        case INS(47 DOWNTO 40) is

            --mov rX, imm32
            when x"B0" =>

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

                    when others =>

                end case;
            
            when x"B3" =>
                case INS(39 DOWNTO 32) is
                    when x"00" =>
                        r0d <= r0d;
                    when x"01" =>
                        r0d <= r1d;
                    when x"02" =>
                        r0d <= r2d;
                    when x"03" =>
                        r0d <= r3d;
                        
                    when x"10" =>
                        r1d <= r0d;
                    when x"11" =>
                        r1d <= r1d;
                    when x"12" =>
                        r1d <= r2d;
                    when x"13" =>
                        r1d <= r3d;
                        
                    when x"20" =>
                        r2d <= r0d;
                    when x"21" =>
                        r2d <= r1d;
                    when x"22" =>
                        r2d <= r2d;
                    when x"23" =>
                        r2d <= r3d;

                    when x"30" =>
                        r3d <= r0d;
                    when x"31" =>
                        r3d <= r1d;
                    when x"32" =>
                        r3d <= r2d;
                    when x"33" =>
                        r3d <= r3d;
                        
                    when others =>

                end case;
            
            when x"A0" =>
                r0 <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) + to_integer(unsigned(r1)),32));
            when x"A2" =>
                r0 <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) - to_integer(unsigned(r1)),32));
            when x"A4" =>
                r0 <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) * to_integer(unsigned(r1)),32));
            --when x"A6" =>
                --r0 <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) + to_integer(unsigned(r1)),32));
            
            when x"A1" =>
                r0d <= std_logic_vector(to_unsigned(to_integer(unsigned(r0d)) + to_integer(unsigned(r1d)),16));
            when x"A3" =>
                r0d <= std_logic_vector(to_unsigned(to_integer(unsigned(r0d)) - to_integer(unsigned(r1d)),16));
            when x"A5" =>
                r0d <= std_logic_vector(to_unsigned(to_integer(unsigned(r0d)) * to_integer(unsigned(r1d)),16));
            --when x"A7" =>
                --r0 <= std_logic_vector(to_unsigned(to_integer(unsigned(r0)) + to_integer(unsigned(r1)),32));

            when others =>

        end case;

    end if;

end process;

end architecture Behavioral;
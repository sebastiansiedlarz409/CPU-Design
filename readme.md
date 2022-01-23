# FPGA base CPU project

My first attempt to project microprocessor on FPGA device. Details:

- 32 bits architecture
- Harvard architecture
- 8 32bits wide registers + Instruction Pointer + Stack Pointer
- Big Endian
- 4Kb RAM
- 4Kb Program Memory
- Each instruction has 1 to 6 bytes
- stack placed at 0xEEC
- GPIO placed at 0xF00

```
mov rX, imm32
B0 [X]F, 00 00 00 00 //big endian

mov rX, rX //32 bits registers
B1 [X][X]

---------------------------------

add r0, r1
A0

sub r0, r1
A2

mul r0, r1
A4

div r0, r1, //rest r2
A6

----------------------------------

and r0, r1
A8

or r0, r1
AA

xor r0, r1
AC

not r0
AE

//unsigned shift left
sul r0, r1
C0

//unsigned shift right
sur r0, r1
C1

//signed shift left
ssl r0, r1
C2

//signed shift right
ssr r0, r1
C3

//rotate unsigned left
rul r0, r1
C4

//rotate unsigned right
rur r0, r1
C5

----------------------------------

push rX
D0 [X]F

pop rX
D2 [X]F

---------------------------------

nop rX
DA [X]F

nop imm32
DB 00 00 00 00

---------------------------------

ldr rX, rX //address, value
E0 [X][X]

str rX, rX
E2 [X][X]

---------------------------------
//IP == rX
jmp rX
F0 [X]F

//IP == imm32
jmp imm32
F1 00 00 00 00

---------------------------------

jz rX
F2 [X]F

jnz rX
F3 [X]F

jz imm32
F4 00 00 00 00

jnz imm32
F5 00 00 00 00

js rX
F6 [X]F

jns rX
F7 [X]F

js imm32
F8 00 00 00 00

jns imm32
F9 00 00 00 00

```

Example program (counting from 9 to 0 in loop on 7segments screen):

```
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
signal FLASH: FLASH_ARRAY := (
x"B0", x"0F", x"00", x"00", x"16", x"FF", --mov r0, 0x16DF //digit 9
x"B0", x"1F", x"00", x"00", x"0F", x"04", 	--mov r1, 0x0F04
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"17", x"FF",   --mov r0, 0x16DF //digit 8
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"10", x"7F",   --mov r0, 0x16DF //digit 7
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"17", x"DF",   --mov r0, 0x16DF //digit 6
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"16", x"DF",   --mov r0, 0x16DF //digit 5
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"16", x"6F",   --mov r0, 0x16DF //digit 4
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"14", x"FF",   --mov r0, 0x16DF //digit 3
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"15", x"BF",   --mov r0, 0x16DF //digit 2
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"10", x"6F",   --mov r0, 0x16DF //digit 1
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"B0", x"0F", x"00", x"00", x"F3", x"FF",   --mov r0, 0xF3FF //digit 0
x"E2", x"10",								                --str r1, r0 //r1 address, r0 value
x"DB", x"00", x"98", x"96", x"80",			    --nop 10 000 000 //sleep 1s
x"F1", x"00", x"00", x"00", x"00",			    --jump to IP = 0
others=> x"00");
```

<img src="https://github.com/sebastiansiedlarz409/FPGA-CPU/blob/master/doc/hw2.jpg"/>
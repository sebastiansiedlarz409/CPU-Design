import argparse
import struct

from instructions import instruction_set

source_filename = ""
output_filename = ""

lines = []
output = bytearray()

regs32 = ["r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "sp", "ip"]
regs16 = ["r0d", "r1d", "r2d", "r3d"]

def openSourceFile():
    global source_filename, lines

    temp = []

    with open(source_filename, "r") as f:
        temp = f.readlines()

    for line in temp:
        line = line.strip()
        lines.append(line)

    print(f"[INFO]: Read {len(lines)} lines")


def splitLine(line, i):
    out = [i]

    f = line.split(" ")
    out.append(f[0])

    if len(f) > 1:
        operands = ""
        for el in f[1:]:
            operands+=el

        s = operands.split(",")
        for operand in s:
            out.append(operand)

    return out

def getOpcode(tokens):
    #filter by instruction name
    filtered_by_name = list(filter(lambda x: x[0]==tokens[1], instruction_set))
    print(filtered_by_name)
    
    if(len(filtered_by_name)==0):
        exit(f"[ERROR]: Unexpected token or unknown opcode for symbol at line {tokens[0]}")
    if(len(filtered_by_name)==1):
        return filtered_by_name[0]

    #filer by operands count
    filtered_by_operand_count = list(filter(lambda x: len(x)+1 == len(tokens)+1, filtered_by_name))
    print(filtered_by_operand_count)

    if(len(filtered_by_operand_count)==0):
        exit(f"[ERROR]: Unexpected token or unknown opcode for symbol at line {tokens[0]}")
    if(len(filtered_by_operand_count)==1):
        return filtered_by_operand_count[0]

    #filter by first argument
    filtered_by_first_arg = list(filter(lambda x: x[1] == tokens[2][1] or x[1]==tokens[2][0] or (x[1].startswith(tokens[2][1]) and x[1][0] != 'r'),
                                 filtered_by_operand_count))
    print(filtered_by_first_arg)
    
    if(len(filtered_by_first_arg)==0):
        exit(f"[ERROR]: Unexpected token or unknown opcode for symbol at line {tokens[0]}")
    if(len(filtered_by_first_arg)==1):
        return filtered_by_first_arg[0]

    #filter by second argument
    filtered_by_second_arg = list(filter(lambda x: x[2] == tokens[3][1] or x[2]==tokens[3][0] or (x[2].startswith(tokens[3][1]) and x[2][0] != 'r'),
                                 filtered_by_first_arg))
    print(filtered_by_second_arg)
    
    if(len(filtered_by_second_arg)==0):
        exit(f"[ERROR]: Unexpected token or unknown opcode for symbol at line {tokens[0]}")
    if(len(filtered_by_second_arg)==1):
        return filtered_by_second_arg[0]
    else:
        exit(f"[ERROR]: Cant choose proper opcode for symbol at line {tokens[0]}")

def getTokenTypes(tokens):
    if len(tokens) == 2:
        return tokens

    t = [tokens[0], tokens[1]]
    #skip first element because its line number
    #skip second element because its instruction name

    for i in range(2, len(tokens)):
        at = [tokens[i]]
        if tokens[i].lower() in regs32:
            at.append("rX")
        elif tokens[i].lower() in regs16:
            at.append("rXd")
        else:
            at.append("imm")
        t.append(at)
    
    return t

def addToOutput(tokens, opcode):
    global output

    #add instruction opcode
    output.append(opcode[len(opcode)-1])

    if opcode[len(opcode)-1] in [0xB0, 0xB1, 0xB2, 0xB3]:
        modrm = 0
        if opcode[1].startswith("r") and tokens[2][0].startswith("r"): #when r0, r1 itp
            modrm |= (int(tokens[2][0][1])<<4)

        if opcode[1].startswith("r") and tokens[2][0].startswith("s"): #sp
            modrm |= 0x80

        if opcode[1].startswith("r") and tokens[2][0].startswith("i"): #ip
            modrm |= 0x90
        
        if opcode[2].startswith("r") and tokens[3][0].startswith("r"):
            modrm |= (int(tokens[3][0][1]))
        elif opcode[2].startswith("r") and tokens[3][0].startswith("s"): #sp
            modrm |= 0x8
        elif opcode[2].startswith("r") and tokens[3][0].startswith("i"): #ip
            modrm |= 0x9
        else:
            modrm |= 0xF

        output.append(modrm)

    arg = 0
    for el in tokens[2:]:
        if opcode[arg+1] == "imm32":
            output += struct.pack(">I", int(el[0]))
        if opcode[arg+1] == "imm16":
            output += struct.pack(">H", int(el[0]))
        arg+=1

def generateOutput():
    global lines, output

    output = bytearray()

    for i in range(0, len(lines)):
        #skip comments
        if lines[i][0] == ";":
            continue
        if len(lines[i].split(";")) > 1:
            lines[i] = lines[i].split(";")[0]
        #print(lines[i])
        tokens = splitLine(lines[i], i+1)
        tokens = getTokenTypes(tokens)
        print(tokens)
        opcode = getOpcode(tokens)
        #add to output
        addToOutput(tokens, opcode)
        print(output)
        print("----")
        #input()

    with open(output_filename, "wb") as f:
        f.write(output)

def main():
    openSourceFile()
    generateOutput()
    print("[INFO]: Done")

if __name__ == "__main__":
    #parse args
    parser = argparse.ArgumentParser()

    parser.add_argument("--s", type=str, help="Source file name [*.asm]", required=True)
    parser.add_argument("--o", type=str, help="Output file name", required=True)

    args = parser.parse_args()
    
    source_filename = args.s
    output_filename = args.o

    main()

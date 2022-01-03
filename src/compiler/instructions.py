instruction_set = [
    ["mov", "rX", "imm32", 0xB0],
    ["mov", "rX", "rX", 0xB1],
    ["add", "r0", "r1", 0xA0],
    ["sub", "r0", "r1", 0xA2],
    ["mul", "r0", "r1", 0xA4],
    ["div", "r0", "r1", 0xA6],
    ["and", "r0", "r1", 0xA8],
    ["or", "r0", "r1", 0xAA],
    ["xor", "r0", "r1", 0xAC],
    ["not", "r0", 0xAE],
    ["push", "rX", 0xD0],
    ["pop", "rX", 0xD2]
]
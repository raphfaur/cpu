semantic = {
    "ADD": "000",
    "SUB": "001",
    "RSHFT": "010",
    "LSHFT": "011",
    "AND": "100",
    "OR": "101",
    "XOR": "110",
    "JMP": "101",
    "INC": "000",
    "DEC": "001",
    "NOP": "010",
}

with open("main.asm") as file:
    lines = file.readlines()
    with open("main.img", "w") as image:
        i = 0
        for line in lines:
            line = line.strip()
            args = line.split(" ")
            print(args)
            op = args[0]
            argc = len(args) - 1
            if argc == 3:
                rdest = args[1]
                ra = args[2]
                rb = args[3]
                if ra[0] == "R" and rb[0] == "R":
                    f = "00"
                    opcode = semantic[op]
                    ra = "{0:03b}".format(int(ra[1]))
                    rb = "{0:03b}".format(int(rb[1]))
                    rdest = "{0:03b}".format(int(rdest[1]))
                    bytecode = f + opcode + rdest + ra + rb + 18 * "0"
                else:
                    f = "01"
                    opcode = semantic[op]
                    ra = "{0:03b}".format(int(ra[1]))
                    rdest = "{0:03b}".format(int(rdest[1]))
                    imm = "{0:016b}".format(int(args[3]))
                    bytecode = f + opcode + rdest + ra + imm + 5 * "0"
            else:
                f = "10"
                if op == "INC" or op == "DEC":
                    opcode = semantic[op]
                    rdest = "{0:03}".format(int(args[1][1]))
                    bytecode = f + opcode + rdest + 24 * "0"
                elif op == "NOP":
                    opcode = semantic[op]
                    bytecode = f + opcode + 27 * "0"
                elif op == "JMP":
                    opcode = semantic[op]
                    imm = "{0:08b}".format(int(args[1]))
                    bytecode = f + opcode + 6 * "0" + imm + 8 * "0" + 5 * "0"
                else:
                    if args[2][0] == "R":
                        opcode = "100"
                        bytecode = (
                            f + opcode + "{0:03b}".format(int(args[1][1])) +  "{0:03b}".format(int(args[2][1])) + 21 * "0"
                        )
                    else:
                        opcode = "011"
                        print( "{0:08b}".format(int(args[1][1]))
)
                        bytecode = (
                            f
                            + opcode
                            + "{0:03b}".format(int(args[1][1]))
                            + 3 * "0"
                            + "{0:016b}".format(int(args[2]))
                            + 5 * "0"
                        )
            image.write(bytecode)
            image.write("\n")
            i += 1
        while i < 256:
            image.write("10010000000000000000000000000000\n")
            i += 1

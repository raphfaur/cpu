

# Basic VHDL CPU with support for FPGA DE10 Lite 💻 </h2>

This repository contains the code I developped in order to build a full-VHDL CPU.  
Some of the files for hardware support (digital 7 seg and dig2dec) were not developed by me.

## Setup :
I personnaly used GHDL 3.0 and Gtkwave on ARM MacOS to run and vizualise all the simulation.
```bash
brew install gtkwave
brew install ghdl
git clone git@github.com:raphfaur/cpu.git
cd cpu/
```

## Build assembly script
Create a file `main.asm` in the `assembly` directory.
```
cd assembly/
touch `main.asm`
```
Write your assembly script. Syntax is the following : `OP arg1 arg2 arg3`. We provide ISA at the end of this introduction.  
Build your `main.img` file :
```
python3 assembler.py
```

## Simulation 📉

```
git checkout main
cd src/
ghdl -a *.vhd
ghdl -r cpu_tb --stop-time=10000ns --wave=wave.ghw
gtkwave wave.ghw
```

## Real FPGA

First you'll need a specific version of VHDL (mainly for LED mapping and RAM init)
```
git switch FPGA
```
Then you'll need to build a `ram.mif` file in order to flash RAM in Quartus.  
A great tool is available there : https://gist.github.com/Towdium/1a2fad63dd3665c064df48b39b41ab01
```
cd assembly/
python3 convert_to_mif.py -d 256 main.img ram.mif
mv ram.mif ../ram.mif
```

Open Quartus and run compilation as you would usually do.

## ISA

| 2b                 | 3b        | 3b  | 3b  | 3b          | 13b      |                      |
| ------------------ | --------- | --- | --- | ----------- | -------- | -------------------- |
| Reg & Reg          |
| Opcode             | Rdest     | RA  | RB  | N/A         | Mnemonic | Function             |
| Format             | Operator  |     |     |             |          |                      |  |
| 00                 | 000       | RID | RID | RID         | N/A      | ADD                  | Rdest= RA + RB |
| 00                 | 001       | RID | RID | RID         | N/A      | SUB                  | Rdest= RA - RB |
| 00                 | 010       | RID | RID | RID         | N/A      | RSHIFT               | Rdest= RSHIFTRA(RB) |
| 00                 | 011       | RID | RID | RID         | N/A      | LSHIT                | Rdest= LSHIFTRA(RB) |
| 00                 | 100       | RID | RID | RID         | N/A      | AND                  | Rdest= RA AND RB |
| 00                 | 101       | RID | RID | RID         | N/A      | OR                   | Rdest= RA OR RB |
| 00                 | 110       | RID | RID | RID         | N/A      | XOR                  | Rdest= RB XOR RA |
| Reg & Imm          |
| Opcode             | Rdest     | RA  | Imm | Mnemonic    | Fonction |
| Format             | Operator  |     |     |             |          |                      |  |
| 01                 | 000       | RID | RID | Imm 16 bits | ADD      | Rdest= RA + Imm      |
| 01                 | 001       | RID | RID | Imm 16 bits | SUB      | Rdest= RA - Imm      |
| 01                 | 010       | RID | RID | Imm 16 bits | RSHIFT   | Rdest= RSHIFTRA(Imm) |
| 01                 | 011       | RID | RID | Imm 16 bits | LSHIT    | Rdest= LSHIFTRA(Imm) |
| 01                 | 100       | RID | RID | Imm 16 bits | AND      | Rdest= RA AND Imm    |
| 01                 | 101       | RID | RID | Imm 16 bits | OR       | Rdest= RA OR Imm     |
| 01                 | 110       | RID | RID | Imm 16 bits | XOR      | Rdest= RA XOR Imm    |
| Special operations |
| Opcode             | Rdest     | RA  | Imm | Mnemonic    | Function |
| Format             | Operator  |     |     |             |          |                      |
| 10                 | 000       | RID | N/A | N/A         | INC      | Rdest = Rdest + 1    |
| 10                 | 001       | RID | N/A | N/A         | DEC      | Rdest = Rdest - 1    |
| 10                 | 010       | N/A | N/A | N/A         | NOP      | No operation         |
| 10                 | 011       | RID | N/A | Imm 16 bits | MOV      | Rdest = Imm          |
| 10                 | 100       | RID | RID | N/A         | MOV      | Rdest = RA           |
| 10                 | 101       | N/A | N/A | Imm 8 bits  | N/A      | JMP                  | Jump to Imm |
| 10                 | 110       | N/A | N/A | Imm 8 bits  | N/A      | JMPZ                 | Jmp if zf = 0 |

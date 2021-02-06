# VHDL Learning Project
This projects aims for learning VHDL basics by designing simple processor.
## Processor Desing
In this study, a simple processor was designed with VHDL in RISC architecture. Since integrated circuit design involves complex computations and extensive use of resources, we can save resources and time by using an HDL, implementing it using a software approach. 
The processor has a 16-bit arithmetic and logical instruction set. The processor has a control unit for arithmetic operations such as ALU (arithmetic logic unit), comparator, shifter. These components are integrated in a control unit with registers and data memory. The processor contains a ROM memory containing the program to be executed and a control unit.
Elements are designed using a behavioral approach. 

## Instruction Set
Instruction | **OpCode** & Other Bits| Description
------------ | ------------------------------ | -------------------
NoOP|**00000** 00000000000 | No operation go next 
LOAD|**00001** 5 Bit MAdr/ 000000|Transfers the value in the bottom line of  current ROM line to memory
MOVERM|**00010** 3 Bit RAdr/ 5Bit MAdr/ 000 | Transfers the value from register to memory
MOVEMR|**00011** 3 Bit RAdr/ 5Bit MAdr/ 000 | Transfers the value from memory to register
MOVERX|**00100** 3 Bit RAdr/ 3Bit RAdr/ 00000 | Transfers the value from register to register
MOVEMX|**00101** 5 Bit MAdr/ 5Bit MAdr/ 0 | Transfers the value from memory to memory
CJUMP|**00110** 3BitRadr/3BitRadr/5BitPCNext | Conditional Jump 
JUMP|**00111** 5BitPCNext/ 000000 | Jump
HALT|**01000** 00000000000 | Stop
.|**ALU OPERATİONS** | Opcode+X+Y+Z(adresses)
ADD|**01100** 3BitRAdr/3Bit RAdr/3Bit RAdr  | r(x) + r(y) => r(z)
SUB|**01101** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) - r(y) => r(z) 
MUL|**01110** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) * r(y) => r(z)
DIV|**01111** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) / r(y) => r(z) 
INC|**10000** 3BitRAdr/ 00000000 | r(x) + 1 => r(x)
DEC|**10001** 3BitRAdr/ 00000000 | r(x) - 1 => r(x) 
AND|**10010** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) and r(y) => r(z) 
OR|**10011** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) or r(y) => r(z) 
XOR|**10100** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) xor r(y) => r(z) 
NOR|**10101** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) nor r(y) => r(z)
NAND|**10110** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) nand r(y) => r(z) 
XNOR|**10111** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) xnor r(y) => r(z)
.|**SHIFTER**  |  
ShiftL|**11010** 3BitRadr/4Bit n/0000 | Shift left n bit r(x) 
ShiftR|**11011** 3BitRadr/4Bit n/0000 | Shift right n bit r(x) 
RotateL|**11100** 3BitRadr/4Bit n/0000 | Rotate left n bit r(x) 
RotateR|**11101** 3BitRadr/4Bit n/0000 | Rotate right n bit r(x)
.|**COMPERATOR** |  
GREATER|**11000** 3BitRAdr/3Bit RAdr/3Bit RAdr |  r(x) ?> r(y) => r(z)
EQUAL|**11000** 3BitRAdr/3Bit RAdr/3Bit RAdr | r(x) ?= r(y) => r(z)

(MAdr:Memory Adress , RAdr:Register Adress) 

## Example ROM Program
Rom program is included in "313965_proccesor.vhd". Compilation and simulation can be done with the "313965.do" script 

ROM LINE | INSTRUCTION
---------|-----------
0=>”0000000000000000” | NoOP
**Count 0 to 3**|
1=>”0000100000000000” | LOAD M(0)
2=>”0000000000000000” | DATA 0
3=>”0001100000000000” | MOVEMR M(0)=>R(0)
4=>”0000100001000000” | LOAD M(1)
5=>”0000000000000011” | DATA 3
6=>”0001100100001000” | MOVEMR M(1)=>R(1)
7=>”1000000000000000” | INC R(1)
8=>”0011000000100111” | CJUMP R(0)<R(1) 00111(7)
9=>”0000000000000000” | NoOP
**5+10=15**|
10=>”0000100011000000” | LOAD M(3)
11=>”0000000000000101” | DATA 5
12=>”0001101100011000” | MOVEMR M(3)=>R(3)
13=>”0000100100000000” | LOAD M(4)
14=>”0000000000001010” | DATA 10
15=>”0001110000100000” | MOVEMR M(4)=>R(4)
16=>”0110001110010100” | ADD R(3) R(4) => R(5)
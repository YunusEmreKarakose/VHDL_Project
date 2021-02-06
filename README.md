# VHDL Learning Project
This projects aims for learning VHDL basics by designing simple processor.
## Processor Desing
In this study, a simple processor was designed with VHDL in RISC architecture. Since integrated circuit design involves complex computations and extensive use of resources, we can save resources and time by using an HDL, implementing it using a software approach. 
The processor has a 16-bit arithmetic and logical instruction set. The processor has a control unit for arithmetic operations such as ALU (arithmetic logic unit), comparator, shifter. These components are integrated in a control unit with registers and data memory. The processor contains a ROM memory containing the program to be executed and a control unit.
Elements are designed using a behavioral approach. 

## Instruction Set
Instruction | OpCode | Description
------------ | -------------
Content from cell 1 | Content from cell 2|cell3
Content in the first column | Content in the second column|cell3
NoOP|<span style="color: blue">00000</span>00000000000 | İşlem yapılmaz  sıradaki komuta geçilir 

LOAD|<span style="color: blue">00001</span> 5 Bit MAdr 000000|RomProgramının, bir alt satırdaki değeri belleğe aktarır 

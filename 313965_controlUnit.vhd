

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.Numeric_Std.all;
use ieee.std_logic_unsigned.all;

entity pControlUnit is
  generic(nob: integer:=16);--16bit number of bits
  port ( clock   : in  std_logic;
	ins:in std_logic_vector(nob-1 downto 0);--instruction
	datain:in std_logic_vector(nob-1 downto 0);--datain
	pc:in std_logic_vector(4 downto 0);--program counter
	pc_next:out std_logic_vector(4 downto 0)--program counter next
	);
end pControlUnit;

architecture Behv of pControlUnit is
--REGISTERS
Type pREG is array(0 to 7) of std_logic_vector(nob-1 downto 0);
signal reg:pREG;
--RAM
Type pDM is array(0 to 31) of std_logic_vector(nob-1 downto 0);
signal dataMem:pDM;
--ALU
signal opcode:std_logic_vector(4 downto 0);
signal alu_in1,alu_in2:std_logic_vector(nob-1 downto 0);
signal alu_out: std_logic_vector(nob-1 downto 0);
signal carry_out:std_logic;
component pALU is
	port(opcode:in std_logic_vector(4 downto 0);
	     alu_in1,alu_in2:in std_logic_vector(nob-1 downto 0);
	     alu_out:out std_logic_vector(nob-1 downto 0);
	     carry_out:out std_logic
	);
end component;
--SHIFTER
signal s_opcode:std_logic_vector(4 downto 0);
signal s_in:std_logic_vector(nob-1 downto 0);
signal s_nob:std_logic_vector(3 downto 0);
signal s_out: std_logic_vector(nob-1 downto 0);
component pShifter is
	Port(opcode:in std_logic_vector(4 downto 0);--opcode for selecting
	     s_in:in std_logic_vector(nob-1 downto 0);--1 input in 16 bit
	     n:in std_logic_vector(3 downto 0);--number of shifted bit in 4 bit
	     s_out:out std_logic_vector(nob-1 downto 0)--output
	     );
End component;
--COMPARATOR
signal c_opcode:std_logic_vector(4 downto 0);
signal c_in1,c_in2:std_logic_vector(nob-1 downto 0);
signal c_out: std_logic;
Component zComp is
	Port(opcode:in std_logic_vector(4 downto 0);
	     c_in1,c_in2:in std_logic_vector(nob-1 downto 0);
	     c_output:out std_logic --output 1-0
	     );
End Component;
--Architecture Begin
begin
--ALU
alu:entity work.palu port Map(
	opcode=>opcode,
	alu_in1=>alu_in1,
	alu_in2 =>alu_in2,
	alu_out=>alu_out,
	carry_out =>carry_out
	);
--SHIFTER
shift:entity work.pshifter port Map(	
	opcode=> s_opcode,
	s_in=>s_in,
	n=>s_nob,
	s_out=>s_out
	);
--COMPARATOR
comp:entity work.pcomp port Map(
	opcode=>c_opcode,
	c_in1=>c_in1,
	c_in2=>c_in2,
	c_output=>c_out
	);

--process
process(clock,ins)
begin	
	case to_integer(unsigned(ins(15 downto 11))) is
	when 0=>--No operations--NOP 00000
		pc_next<=pc+1;
	when 1=>--LOAD data to ram 00101
		if(datain/="XXXXXXXXXXXXXXXX")then
		dataMem(to_integer(unsigned(ins(10 downto 6))))<=datain;
		end if;
		pc_next<=pc+2;
	when 2=>--MOVE from mem(mem_adrs) to reg(reg_adrs)--MOVERM 00010
		dataMem(to_integer(unsigned(ins(7 downto 3))))<=reg(to_integer(unsigned(ins(10 downto 8))));
		pc_next<=pc+1;
	when 3=>--MOVE from mem(mem_adrs) to reg(reg_adrs)--MOVEMR 00001
		reg(to_integer(unsigned(ins(10 downto 8))))<=dataMem(to_integer(unsigned(ins(7 downto 3))));	
		pc_next<=pc+1;
	when 4=>--MOVE from reg(reg_adrs2) to reg(reg_adrs1)--MOVERX 00011
		reg(to_integer(unsigned(ins(10 downto 8))))<=reg(to_integer(unsigned(ins(7 downto 5))));
		pc_next<=pc+1;
	when 5=>--MOVE from mem(mem_adrs1) to mem(mem_adrs2)--MOVEMX 00100
		dataMem(to_integer(unsigned(ins(10 downto 6))))<=dataMem(to_integer(unsigned(ins(5 downto 1))));
		pc_next<=pc+1;
	when 6=>--CJUMP if reg1<reg2 00110
		if(reg(to_integer(unsigned(ins(10 downto 8))))<reg(to_integer(unsigned(ins(7 downto 5)))))then
			pc_next<=ins(4 downto 0);
		else
			pc_next<=pc+1;
		end if;
	when 7=>--JUMP 
		pc_next<=ins(10 downto 6);
	when 8=>--Halt(stop)00111
		null;
	when 12 to 23 =>--ALU OPERATIONS
		opcode<=ins(15 downto 11);
		alu_in1<=reg(to_integer(unsigned(ins(10 downto 8))));--reg1 content
		alu_in2<=reg(to_integer(unsigned(ins(7 downto 5))));--reg2 content
		--reg(to_integer(unsigned(ins(12 downto 9))))<=alu_out;--write to reg3 result
		pc_next<=pc+1;
	when 24 to 25 =>--Comparator
		c_opcode<=ins(15 downto 11);		
		c_in1<=reg(to_integer(unsigned(ins(10 downto 8))));--reg1 content
		c_in2<=reg(to_integer(unsigned(ins(7 downto 5))));--reg2 content
		--reg(to_integer(unsigned(ins(12 downto 9))))<=x"00"+c_out;--write to reg3 result
		pc_next<=pc+1;
	when 26 to 29=>--shifter
		s_opcode<=ins(15 downto 11);
		s_in<=reg(to_integer(unsigned(ins(10 downto 8))));--reg content
		s_nob<=ins(7 downto 4);--number of shifted bits
		--reg(to_integer(unsigned(ins(20 downto 17))))<=s_out;--write back reg	
		pc_next<=pc+1;	
	when others => null;	
	end case;
	if(falling_edge(clock))then
	case to_integer(unsigned(ins(15 downto 11))) is
	when 12 to 23 =>--ALU OPERATIONS		
		reg(to_integer(unsigned(ins(4 downto 2))))<=alu_out;--write to reg3 result
	when 24 to 25 =>--Comparator
		reg(to_integer(unsigned(ins(4 downto 2))))<=x"00"+c_out;--write to reg3 result
	when 26 to 29=>--shifter
		reg(to_integer(unsigned(ins(10 downto 8))))<=s_out;--write back reg	
	when others => null;	
	end case;
	end if;
end process;

end architecture Behv;

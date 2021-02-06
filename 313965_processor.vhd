
Library IEEE,STD;
Use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity processor is
  generic(nob: integer:=16);--16bit number of bits
  port ( clock   : in  std_logic;
	reset:in std_logic
	);
end processor;

architecture Behv of processor is
--ROM
Type pROM is array(0 to 31) of std_logic_vector(nob-1 downto 0);
signal rom:pROM:=(
		0=>"0000000000000000",
		1=>"0000100000000000",--to mem(0) 		LOAD M(0)
		2=>"0000000000000000",--0
		3=>"0001100000000000",--mem(0) to reg(0) 	MOVEMR M(0)=>R(0)
		4=>"0000100001000000",--to mem(1)		LOAD M(1)
		5=>"0000000000000011",--3
		6=>"0001100100001000",--mem(1) to reg(1)	MOVEMR M(1)=>R(1)
		7=>"1000000000000000",--reg(0)++		INC R(1)
		8=>"0011000000100111",--jump 7 if reg(0)<reg(1)	CJUMP R(0)<R(1) 00111(7)
		9=>"0000000000000000",
		10=>"0000100011000000",--to mem(3)		LOAD M(3)
		11=>"0000000000000101",--5
		12=>"0001101100011000",--mem(3) to reg(3)	MOVEMR M(3)=>R(3)
		13=>"0000100100000000",--to mem(4)		LOAD M(4)
		14=>"0000000000001010",--10
		15=>"0001110000100000",--mem(4) to reg(4)	MOVEMR M(4)=>R(4)
		16=>"0110001110010100",--reg(3)+reg(4) to reg(5)ADD R(3) R(4) => R(5)
			OTHERS=>"0000000000000000");
--Control Unit
signal ins:std_logic_vector(nob-1 downto 0);
signal datain:std_logic_vector(nob-1 downto 0);
signal pc:std_logic_vector(4 downto 0):="00000";--program counter
signal comp_out: std_logic;--comperator output
signal pc_next: std_logic_vector(4 downto 0);--program counter next
signal pc_lim:std_logic_vector(4 downto 0):="11111";
component pControlUnit is
	port(	clock   : in  std_logic;
		ins:in std_logic_vector(nob-1 downto 0);--instruction
		datain:in std_logic_vector(nob-1 downto 0);--datain
		pc:in std_logic_vector(4 downto 0);--program counter
		pc_next:out std_logic_vector(4 downto 0)--program counter next
	);
end component;
--begin arch
begin
cu:entity work.pcontrolunit port Map(
	clock=>clock,
	ins=>ins,
	datain=>datain,
	pc=>pc,
	pc_next=>pc_next
	);
process(clock)
begin
if rising_edge(clock) then	
	ins<=rom(to_integer(unsigned(pc)));
	pc<=pc;
	datain<=rom(to_integer(unsigned(pc+1)));
end if;
if falling_edge(clock)then
	pc<=pc_next;	
end if;
end process;
end architecture Behv;

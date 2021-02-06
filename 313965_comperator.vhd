
Library IEEE,STD;
Use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
--inputs
-- opcode(5bit) register_1_content(B bit) register_2_content(B bit)
--output
--c_output (1 bit)
Entity pComp is
        generic ( 
	     constant B: natural := 15  --number of bits-1
    	);
	Port(opcode:in std_logic_vector(4 downto 0);--opcode for selecting
	     c_in1,c_in2:in std_logic_vector(B downto 0);--2 inputs in B bit
	     c_output:out std_logic--output 1-0
	     );
End pComp;


Architecture Behv of pComp is
signal tmp:std_logic;
begin
   process(c_in1,c_in2,opcode)
 begin
  case(opcode) is
  when "11000" => -- Greater comparison
   if(c_in1>c_in2) then
    tmp <= '1' ;
   else
    tmp <= '0' ;
   end if; 
  when "11001" => -- Equal comparison   
   if(c_in1=c_in2) then
    tmp <= '1' ;
   else
    tmp <= '0' ;
   end if;
  when others => tmp <= '0' ; 
  end case;
 end process;
 c_output <= tmp; -- ALU out

End Behv;

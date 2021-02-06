

Library IEEE,STD;
Use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
--inputs
--opcode(5bit) register_1_content(B bit) register_2_content(B bit)
--output
--alu_out(B bit) carry_out(1bit)
Entity pALU is
        generic ( 
	     constant B: natural := 15  --number of bits-1
    	);
	Port(opcode:in std_logic_vector(4 downto 0);--opcode for selecting
	     alu_in1,alu_in2:in std_logic_vector(B downto 0);--2 inputs in B bit
	     alu_out:out std_logic_vector(B downto 0);--output
	     carry_out:out std_logic);--carryout
End pALU;


Architecture Behv of pALU is
signal tmp: std_logic_vector (B+1 downto 0);

begin
   process(alu_in1,alu_in2,opcode)
 begin
  case(opcode) is
  when "01100" => -- Addition
   alu_out <= alu_in1 + alu_in2 ; 
  when "01101" => -- Subtraction
   alu_out <= alu_in1 - alu_in2 ;
  when "01110" => -- Multiplication
   alu_out <= std_logic_vector(to_unsigned((to_integer(unsigned(alu_in1)) * to_integer(unsigned(alu_in2))),B+1)) ;
  when "01111" => -- Division
   alu_out <= std_logic_vector(to_unsigned(to_integer(unsigned(alu_in1)) / to_integer(unsigned(alu_in2)),B+1)) ;
  when "10000"=> --Increment input1
    alu_out<= alu_in1+1;
  when "10001"=> --Decrement input1
    alu_out<= alu_in1-1;
  when "10010" => -- Logical and 
   alu_out <= alu_in1 and alu_in2;
  when "10011" => -- Logical or
   alu_out <= alu_in1 or alu_in2;
  when "10100" => -- Logical xor 
   alu_out <= alu_in1 xor alu_in2;
  when "10101" => -- Logical nor
   alu_out <= alu_in1 nor alu_in2;
  when "10110" => -- Logical nand 
   alu_out <= alu_in1 nand alu_in2;
  when "10111" => -- Logical xnor
   alu_out <= alu_in1 xnor alu_in2;
  when others => alu_out <= alu_in1 + alu_in2 ; 
  end case;
 end process;
 tmp <= ('0' & alu_in1) + ('0' & alu_in2);
 carry_out <= tmp(B+1); -- Carryout flag

End Behv;

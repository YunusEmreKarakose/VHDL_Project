


Library IEEE,STD;
Use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
--inputs
-- opcode(5bit) register_1_content(B bit) number of shifted or rotated bits 4 bit(0-15 range)
--output
--s_out(B bit)
Entity pShifter is
        generic ( 
	     constant B: natural := 15  --number of bits-1
    	);
	Port(opcode:in std_logic_vector(4 downto 0);--opcode for selecting
	     s_in:in std_logic_vector(B downto 0);--1 input in 16 bit
	     n:in std_logic_vector(3 downto 0);--
	     s_out:out std_logic_vector(B downto 0)--output
	     );
End pShifter;


Architecture Behv of pShifter is
signal tmp: std_logic_vector (B downto 0);
begin
   process(s_in,opcode)
 begin
  case(opcode) is
  when "11010" => -- Logical shift left
   s_out <= std_logic_vector(unsigned(s_in) sll to_integer(unsigned(n)));
  when "11011" => -- Logical shift right
   s_out <= std_logic_vector(unsigned(s_in) srl to_integer(unsigned(n)));
  when "11100" => --  Rotate left
   s_out <= std_logic_vector(unsigned(s_in) rol to_integer(unsigned(n)));
  when "11101" => -- Rotate right
   s_out <= std_logic_vector(unsigned(s_in) ror to_integer(unsigned(n)));
  when others => tmp <= s_in ; 
  end case;
 end process;
End Behv;

Library IEEE,STD;
Use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity processorTB is
end processorTB;

architecture Behv of processorTB is
constant clk_period : time := 100 ns;
--PROCESSOR
signal clk:std_logic;
signal rst:std_logic;
Component Processor is
	Port(
	clock  : in  std_logic;
	reset  : in std_logic
);
End Component;
begin
p:entity work.processor Port Map(
	clock=>clk,
	reset=>rst
);
process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;
end architecture Behv;

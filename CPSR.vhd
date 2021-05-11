library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity CPSR is
port(
	clk : in std_logic;
	cpsr_enable : in std_logic_vector(3 downto 0);
	cpsr_in : in std_logic_vector(3 downto 0);
	cpsr_out : out std_logic_vector(3 downto 0)
);
end;

architecture synth of CPSR is
begin
	process(clk) begin
		if rising_edge(clk) then
			if cpsr_enable(0) then
				cpsr_out(0) <= cpsr_in(0);
			end if;
			if cpsr_enable(1) then
				cpsr_out(1) <= cpsr_in(1);
			end if;
			if cpsr_enable(2) then
				cpsr_out(2) <= cpsr_in(2);
			end if;
			if cpsr_enable(3) then
				cpsr_out(3) <= cpsr_in(3);
			end if;
		end if;
	end process;
end;
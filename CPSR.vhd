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
			if cpsr_enable = "1111" then
				cpsr_out <= cpsr_in;
			end if;
		end if;
	end process;
end;
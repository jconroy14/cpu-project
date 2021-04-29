library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity immextend is
	port(imm : in std_logic_vector(11 downto 0);
		 immout : out std_logic_vector(31 downto 0)
	);
end;

architecture synth of immextend is
	signal rot : unsigned(3 downto 0);
	signal vals : unsigned(31 downto 0);
begin
	vals <= unsigned(24d"0" & imm(7 downto 0));
    rot <= unsigned(imm(11 downto 8));

	process(all) begin
		for i in 0 to 31 loop
			immout(i) <= vals(to_integer(rot + i));
		end loop;
	end process;
end;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pcbench is 

end pcbench;



architecture test of pcbench is 

component add8 is
port(
	x : in unsigned(31 downto 0);
	xplus8 : out unsigned(31 downto 0)
);
end component;

signal int: unsigned(31 downto 0);
signal xplus8 : unsigned(31 downto 0);

begin 
add: add8 port map(int, xplus8);
	process begin 
	for r in 0 to 40 loop
	    int <= to_unsigned(r,int'length);
		
		
		wait for 1 sec;
		
		assert xplus8 = to_unsigned(r+8, xplus8'length);
		
	end loop;
	wait;
	end process;


end;

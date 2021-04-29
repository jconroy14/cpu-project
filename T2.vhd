library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
	
use std.textio.all;


entity romtest is 

end romtest;

architecture test of romtest is 

component progrom
	port(
	addr : in unsigned(31 downto 0);
	data : out std_logic_vector(31 downto 0)
	);
end component;

signal addr :  unsigned(31 downto 0):= (others => '0');
signal data :  std_logic_vector(31 downto 0):= (others => '0');
signal diff: integer:=0;
begin 

rom:progrom port map(addr,data);

process is 
begin 
report "hi";
addr <=  "00000000000000000000000000000001";
for k in 0 to 11 loop 
	addr <=  to_unsigned(k, addr'length);
	diff <= 11-k;
	wait for 1 sec;
    if (to_integer(unsigned(data)) /= diff) then 
	   report "Failure not correct Data. Data: "& integer'image(to_integer(unsigned(data))) & " Diff: " &integer'image(diff);
	end if;
	report "Success data :" & integer'image(to_integer(unsigned(data)));
    report "address: "& integer'image(to_integer(addr));
	wait for 1 sec;

end loop;
wait;
end process;
 
end test;
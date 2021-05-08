library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity imm_testbench is
end;

architecture sim of imm_testbench is
	component immextend is
		port(
			op  : in std_logic_vector(1 downto 0);
			imm : in std_logic_vector(11 downto 0);
			immout : out std_logic_vector(31 downto 0)
		);
	end component;
	signal op : std_logic_vector(1 downto 0);
	signal imm : std_logic_vector(11 downto 0);
	signal immout : std_logic_vector(31 downto 0);
begin
	dut : immextend port map(op, imm, immout);
	op <= "00";
	
	process begin
		imm <= 4d"0" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"15") report "Test 1 failed";
		
		imm <= 4d"1" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"3221225475") report "Test 2 failed";

		imm <= 4d"0" & 8d"0";
		wait for 10 ns;
		assert (immout = 32d"0") report "Test 3 failed";
		
		write(output, "All tests passed!" & LF);
		wait;
	end process;
end;
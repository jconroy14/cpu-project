library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity test is
end;

architecture test of test is
	component immextend is
		port(
			op  : in std_logic_vector(1 downto 0);
			imm : in std_logic_vector(11 downto 0);
			immout : out std_logic_vector(31 downto 0)
		);
	end component;
	signal op : std_logic_vector(1 downto 0):= 2d"0";
	signal imm : std_logic_vector(11 downto 0):= 12d"0";
	signal immout : std_logic_vector(31 downto 0):= 32d"0";
begin
	dut : immextend port map(op, imm, immout);
	op <= "00";
	
	process begin
		imm <= 4d"0" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"15") report "Test 1 failed"severity failure;
		
		imm <= 4d"1" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"3221225475") report "Test 2 failed" severity failure;

		imm <= 4d"0" & 8d"0";
		wait for 10 ns;
		assert (immout = 32d"0") report "Test 3 failed";
		
		write(output, "All initial tests passed!" & LF);
		
		imm <= 4d"2" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"4026531840") report "Test 2 failed" severity failure;
        
		imm <= 4d"3" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"1006632960") report "Test 2 failed" severity failure;
        
		imm <= 4d"2" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"4026531840") report "Test 2 failed" severity failure;
        
		imm <= 4d"3" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"1006632960") report "Test 2 failed" severity failure;

        imm <= 4d"4" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"251658240") report "Test 2 failed" severity failure;

        imm <= 4d"5" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"62914560") report "Test 2 failed" severity failure;
         
		 
		imm <= 4d"6" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"15728640") report "Test 2 failed" severity failure;
         
	
		imm <= 4d"7" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"3932160") report "Test 2 failed" severity failure;
         
		imm <= 4d"8" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"983040") report "Test 2 failed" severity failure;
        
		imm <= 4d"9" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"245760") report "Test 2 failed" severity failure;
         
		imm <= 4d"10" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"61440") report "Test 2 failed" severity failure;

        imm <= 4d"11" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"15360") report "Test 2 failed" severity failure;

		imm <= 4d"12" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"3840") report "Test 2 failed" severity failure;
         
	
		imm <= 4d"13" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"960") report "Test 2 failed" severity failure;
         
		imm <= 4d"14" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"240") report "Test 2 failed" severity failure;
         
		
		imm <= 4d"15" & 8d"15";
		wait for 10 ns;
		assert (immout = 32d"60") report "Test 2 failed" severity failure;
         
		write(output, "All final tests passed!" & LF);
		wait;
	end process;
end;
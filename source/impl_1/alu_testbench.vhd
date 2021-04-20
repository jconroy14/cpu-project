library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity alu_testbench is
end;

architecture sim of alu_testbench is
    component alu is
        port(
            srcA    : in  std_logic_vector (31 downto 0);
            srcB    : in  std_logic_vector (31 downto 0);
            command : in  std_logic_vector (3  downto 0);
            result  : out std_logic_vector (31 downto 0);
            flags   : out std_logic_vector (3  downto 0) -- NZCV 
        );
    end component;

	signal srcA    :  std_logic_vector (31 downto 0) := 32d"0";
	signal srcB    :  std_logic_vector (31 downto 0) := 32d"0";
	signal command :  std_logic_vector (3  downto 0) := 4d"0";
	signal result  :  std_logic_vector (31 downto 0) := 32d"0";
	signal flags   :  std_logic_vector (3  downto 0) := 4d"0";

begin
    --instantiate device under test
    dut: alu port map(srcA, srcB, command, result, flags);
    
    --apply inputs one at a time, checking results
    process begin
        srcA <= 32d"15";
        srcB <= 32d"20";
        command <= "0100";
        wait for 10 ns;
        assert (result = 32d"35" and flags = "0000") report "Test 1 failed (15 + 20).";
		
        srcA <= 32d"15";
        srcB <= 32d"20";
        command <= "0010";
        wait for 10 ns;
        assert (result = 32x"FFFFFFFB" and flags = "1010") report "Test 2 failed (15 - 20).";
		
		-- 3 tests based on examples from the spec
		srcA <= 32x"7FFFFFFF";
        srcB <= 32x"1";
        command <= "0100";
        wait for 10 ns;
        assert (result = 32x"80000000" and flags = "1001") report "Test 3 failed (0111... + 1).";
		
		srcA <= 32x"FFFFFFFF";
        srcB <= 32x"FFFFFFFF";
        command <= "0100";
        wait for 10 ns;
        assert (result = 32x"FFFFFFFE" and flags = "1010") report "Test 4 failed (-1 + -1).";
		
		srcA <= 32x"80000000";
        srcB <= 32x"FFFFFFFF";
        command <= "0100";
        wait for 10 ns;
        assert (result = 32x"7FFFFFFF" and flags = "0011") report "Test 5 failed (100... + -1).";

		write(output, "All tests passed." & LF);
		
        wait;
    end process;
end;
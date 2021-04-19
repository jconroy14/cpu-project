library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_testbench is
	port(passed : out std_logic);
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

	signal srcA    :  std_logic_vector (31 downto 0);
	signal srcB    :  std_logic_vector (31 downto 0);
	signal command :  std_logic_vector (3  downto 0);
	signal result  :  std_logic_vector (31 downto 0);
	signal flags   :  std_logic_vector (3  downto 0);

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
        assert (result = 32d"-5" and flags = "1000") report "Test 2 failed (15 - 20).";

        wait;
    end process;
end;
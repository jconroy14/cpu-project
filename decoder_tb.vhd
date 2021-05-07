library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder_testbench is
end;

architecture sim of decoder_testbench is

component decoder is
port(
	instruction : in std_logic_vector(31 downto 0);
	aluControl : out std_logic_vector(3 downto 0);
	addrA : out unsigned(3 downto 0);
	addrB : out unsigned(3 downto 0);
	addrC : out unsigned(3 downto 0);
	useImm : out std_logic
);
end component;

signal instruction : std_logic_vector(31 downto 0);
signal aluControl : std_logic_vector(3 downto 0);
signal addrA : unsigned(3 downto 0);
signal addrB: unsigned(3 downto 0);
signal addrC : unsigned(3 downto 0);
signal useImm : std_logic;
	
begin

	dut : decoder port map (instruction => instruction, aluControl => aluControl, addrA => addrA, addrB => addrB, addrC => addrC, useImm => useImm);

	process begin
		instruction <= 32x"00000000"; wait for 10 ns;
		assert aluControl = "0000" report "aluControl failed";
		assert addrA = "0000" report "addrA failed";
		assert addrB = "0000" report "addrB failed";
		assert addrC = "0000" report "addrC failed";
		assert useImm = '0' report "useImm failed";
		
		instruction <= "01000111010110101011110101010101"; wait for 10 ns;
		assert aluControl = "1010" report "aluControl failed";
		assert addrA = "1010" report "addrA failed";
		assert addrB = "0101" report "addrB failed";
		assert addrC = "1011" report "addrC failed";
		assert useImm = '1' report "useImm failed";
		
		wait;
	end process;
end;
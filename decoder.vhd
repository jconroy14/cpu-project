library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity decoder is
port(
	instruction : in std_logic_vector(31 downto 0);
	cond : out std_logic_vector(3 downto 0);
	op : out std_logic_vector(1 downto 0);
	useImm : out std_logic;
	aluCommand : out std_logic_vector(3 downto 0);
	Rn : out unsigned(3 downto 0);
	Rd : out unsigned(3 downto 0);
	Rm : out unsigned(3 downto 0);
	imm : out std_logic_vector(23 downto 0);
	performLoad : out std_logic;
	FlagWrite:out std_logic
);

end;


architecture synth of decoder is
begin
	cond <= instruction(31 downto 28);
	op <= instruction(27 downto 26);
	imm <= instruction(23 downto 0);
	
	-- "Data-processing" encoding
	useImm <= instruction(25);
	aluCommand <= instruction(24 downto 21);
	Rn <= unsigned(instruction(19 downto 16));
	Rd <= unsigned(instruction(15 downto 12));
	Rm <= unsigned(instruction(3 downto 0));
	FlagWrite <= instruction(20);
	
	-- "Memory" encoding (Rn and Rm stay the same)
	performLoad <= instruction(20);
	-- "Branch" encoding
	-- imm24 <= instruction(23 downto 0);
end;
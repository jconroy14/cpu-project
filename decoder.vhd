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
	imm12 : out std_logic_vector(11 downto 0);
	performLoad : out std_logic;
	writeToReg : out std_logic
);

end;


architecture synth of decoder is
	signal isMemOp : std_logic;
	signal aluCommand_raw : std_logic_vector(3 downto 0);
	signal useImm_raw : std_logic;
begin
	cond <= instruction(31 downto 28);
	op <= instruction(27 downto 26);
	
	-- "Data-processing" encoding
	useImm_raw <= instruction(25) or isMemOp;
	aluCommand_raw <= instruction(24 downto 21);
	Rn <= unsigned(instruction(19 downto 16));
	Rd <= unsigned(instruction(15 downto 12));
	Rm <= unsigned(instruction(3 downto 0));
	imm12 <= instruction(11 downto 0);
	
	-- "Memory" encoding (Rn and Rm stay the same)
	isMemOp <= '1' when op = "01" else '0';
	performLoad <= instruction(20) and isMemOp;
	useImm <= useImm_raw or isMemOp; --For memory operations, we always use the immediate value
	aluCommand <= 4b"0100" when isMemOp else aluCommand_raw; -- For memory operations, we always add imm and Rn
	-- "Branch" encoding
	-- imm24 <= instruction(23 downto 0);
	
	-- Don't write to register if (a) there is a "STR" instruction, or (b) Rd = 15
	writeToReg <= '1' when not(((op = "01") and (performLoad = '0')) or (Rd = 4d"15")) else '0';
end;
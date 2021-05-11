library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_module is
	port (
		resetPC : in std_logic;
		clk : in std_logic;
		output : out std_logic_vector(31 downto 0);
		out_pc : out unsigned(31 downto 0);
		out_instruction : out std_logic_vector(31 downto 0);
		out_immout : out std_logic_vector(31 downto 0);
		out_srcB : out std_logic_vector(31 downto 0);
		out_op : out std_logic_vector(1 downto 0);
		out_aluresult : out std_logic_vector(31 downto 0);
		out_rn_contents : out std_logic_vector(31 downto 0);
		out_src_b_contents : out std_logic_vector(31 downto 0);
		out_ram_write : out std_logic;
		out_ram_result : out std_logic_vector(31 downto 0);
		out_reg_write : out std_logic;
		out_imm24 : out std_logic_vector(23 downto 0)
	);
end;

architecture synth of top_module is

component HSOSC is
  generic(
      CLKHF_DIV : String := "0b00"); -- Divide 48MHz clock by 2ˆN (0-3)
  port(
      CLKHFPU :in std_logic := 'X'; -- Set to 1 to power up
	  CLKHFEN :in std_logic := 'X'; -- Set to 1 to enable output
	  CLKHF :out std_logic := 'X'); -- Clock output
 end component;

component alu is
port(
	srcA : in std_logic_vector(31 downto 0);
	srcB : in std_logic_vector(31 downto 0);
	command : in std_logic_vector(3 downto 0);
	result : out std_logic_vector(31 downto 0);
	flags : out std_logic_vector(3 downto 0) -- NZCV
);
end component;

component programcounter is
port(
	clk : in std_logic;
	reset : in std_logic;
	branch : in std_logic;
	branchAddr : in std_logic_vector(31 downto 0);
	pc : out unsigned(31 downto 0)
);
end component;

component regfile is
port(
	clk : in std_logic;
	A1 : in unsigned(3 downto 0); -- Address for port 1 (read 1)
	A2 : in unsigned(3 downto 0); -- Address for port 2 (read 2)
	A3 : in unsigned(3 downto 0); -- Address for port 3 (write 3)
	WE3 : in std_logic; -- Write enable for port 3
	R15 : in std_logic_vector(31 downto 0); -- Passthrough for PC+8
	RD1 : out std_logic_vector(31 downto 0); -- Data result for port 1
	RD2 : out std_logic_vector(31 downto 0); -- Data result for port 2
	WD3 : in std_logic_vector(31 downto 0) -- Data input for port 3
);
end component;

component progrom is
port(
	addr : in unsigned(31 downto 0);
	data : out std_logic_vector(31 downto 0)
);
end component;

component immextend is
port(
	op : in std_logic_vector(1 downto 0);
	imm : in std_logic_vector(23 downto 0);
	immout : out std_logic_vector(31 downto 0)
);
end component;

component add8 is
port(
	x : in unsigned(31 downto 0);
	xplus8 : out unsigned(31 downto 0)
);
end component;

component control_module is
port(
	clk : std_logic;
	instruction : in std_logic_vector(31 downto 0);
	op : out std_logic_vector(1 downto 0);
	useImm : out std_logic;
	aluCommand : out std_logic_vector(3 downto 0);
	Rn : out unsigned(3 downto 0); -- address of first operand
	Rd : out unsigned(3 downto 0); -- address of the input register, where the result of Rn and Src2 will be stored
	Rm : out unsigned(3 downto 0); -- address of the second operand (if useImm = 1, use imm12 instead)
	imm : out std_logic_vector(23 downto 0);
	writeToRam : out std_logic;
	writeToReg : out std_logic;
	branch : out std_logic;
	aluFlags : in std_logic_vector(3 downto 0)
);
end component; 

component ram is
port(
    clk          : in std_logic;
    write_enable : in std_logic;
    addr         : in unsigned (31 downto 0);
    write_data   : in unsigned (31 downto 0);
    read_data    : out unsigned (31 downto 0)
);
end component;

--clock: FOR TESTING ONLY, make this an input

--signal clk: std_logic := '0';

--programcounter

--signal resetPC : std_logic;

signal useBranch : std_logic := '0';
signal branchAddr : std_logic_vector(31 downto 0) := 32d"0";
signal pc: unsigned(31 downto 0);

signal instruction : std_logic_vector(31 downto 0);
--controller
signal op : std_logic_vector(1 downto 0);
signal aluCommand : std_logic_vector(3 downto 0);
signal Rn, Rm, Rd: unsigned(3 downto 0);
signal useImm : std_logic;
signal imm : std_logic_vector(23 downto 0);
signal performLoad : std_logic;
signal writeToReg : std_logic;
--immextend
signal immout : std_logic_vector(31 downto 0);
--regfile
signal pcp8 : unsigned(31 downto 0);
signal srcB_reg : unsigned(3 downto 0); 
signal Rn_contents, srcB_reg_contents : std_logic_vector(31 downto 0);
signal result : std_logic_vector(31 downto 0);
--ALU
signal alu_result : std_logic_vector(31 downto 0);
signal srcB : std_logic_vector(31 downto 0);
signal flags : std_logic_vector(3 downto 0);
--RAM
signal writeToRam : std_logic;
signal ram_result : unsigned(31 downto 0);

begin
	--clock : HSOSC port map('1', '1', clk);
	
	-- Fetch and decode instruction
	rom : progrom port map(addr => pc, data => instruction);
	progcount : programcounter port map(clk => clk, reset => resetPC, branch => useBranch, branchAddr => alu_result, pc => pc);
	controller : control_module port map(op => op, instruction => instruction,
							   aluCommand => aluCommand, Rn => Rn, Rm => Rm, Rd => Rd,
							   useImm => useImm, imm => imm, writeToRam => writeToRam,
							   writeToReg => writeToReg, clk => clk, aluFlags => flags,
							   branch => useBranch);
							   
	-- Read from register (and write old value to register)
	pc8 : add8 port map(x => pc, xplus8 => pcp8);
	srcB_reg <= Rd when op = "01" else Rm;
	reg : regfile port map(clk => clk, A1 => Rn, A2 => srcB_reg, A3 => Rd, WE3 => writeToReg, R15 => std_logic_vector(pcp8), RD1 => Rn_contents, RD2 => srcB_reg_contents, WD3 => result);

	-- Deal with data-processing operations (ie. compute alu_result)
	immex : immextend port map(op => op, imm => imm, immout => immout);
	srcB <= immout when useImm else srcB_reg_contents;
	myalu : alu port map(srcA => Rn_contents, srcB => srcB, command => aluCommand, result => alu_result, flags => flags);
	
	-- Deal with memory operations
	myRam : ram port map (clk => clk, write_enable => writeToRam, addr => unsigned(alu_result), write_data => unsigned(srcB_reg_contents), read_data => ram_result);

	-- Select correct result
	result <= alu_result when (op = "00" or op = "10") else
			  std_logic_vector(ram_result) when op = "01" else
			  32d"0";

	-- Output signals
	output <= result;
	out_pc <= pc;
	out_instruction <= instruction;
	out_immout <= immout;
	out_srcB <= srcB;
	out_op <= op;
	out_aluresult <= alu_result;
	out_rn_contents <=Rn_contents;
	out_src_b_contents <= srcB_reg_contents;
	out_ram_write <= writeToRam;
	out_reg_write <= writeToReg;
	out_ram_result <= std_logic_vector(ram_result);
	out_imm24 <= imm;
end;
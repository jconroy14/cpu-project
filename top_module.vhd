library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_module is
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
	imm : in std_logic_vector(11 downto 0);
	immout : out std_logic_vector(31 downto 0)
);
end component;

component add8 is

port(
	x : in unsigned(31 downto 0);
	xplus8 : out unsigned(31 downto 0)
);
end component;

component decoder is
port(
	instruction : in std_logic_vector(31 downto 0);
	aluControl : out std_logic_vector(3 downto 0);
	addrA : out unsigned(3 downto 0); --Rn, address of first operand
	addrB : out unsigned(3 downto 0); --Src2, address of second operand (if useImm = 0, otherwise second operand is the imediate value 7 downto 0)
	addrC : out unsigned(3 downto 0); --Rd, address of the input register, where the result of Rn and Src2 will be stored
	useImm : out std_logic
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

--clock
signal clk: std_logic;
--programcounter
signal resetPC : std_logic;
signal useBranch : std_logic;
signal branchAddr : std_logic_vector(31 downto 0);
signal pc: unsigned(31 downto 0);

signal instruction : std_logic_vector(31 downto 0);
--decoder
signal aluCommand : std_logic_vector(3 downto 0);
signal Rn, Rm, Rd: unsigned(3 downto 0);
signal useImm : std_logic;
--immextend
signal imm : std_logic_vector(11 downto 0);
signal immout : std_logic_vector(31 downto 0);
--regfile
signal pcp8 : unsigned(31 downto 0);
signal RD1, RD2 : std_logic_vector(31 downto 0);
signal WD3 : std_logic_vector(31 downto 0);
--ALU
signal srcB : std_logic_vector(31 downto 0);
signal flags : std_logic_vector(3 downto 0);

begin
	clock : HSOSC port map('1', '1', clk);

	rom : progrom port map(addr => pc, data => instruction);
	progcount : programcounter port map(clk => clk, reset => resetPC, branch => useBranch, branchAddr => branchAddr, pc => pc);
	decode : decoder port map(instruction => instruction, aluControl => aluCommand, addrA => Rn, addrB => Rm, addrC => Rd, useImm => useImm);
	immex : immextend port map(op => instruction(27 downto 26), imm => instruction(11 downto 0), immout => immout);
	pc8 : add8 port map(x => pc, xplus8 => pcp8);
	reg : regfile port map(clk => clk, A1 => Rn, A2 => Rm, A3 => Rd, WE3 => '1', R15 => std_logic_vector(pcp8), RD1 => RD1, RD2 => RD2, WD3 => WD3);
	srcB <= immout when useImm else RD2;
	myalu : alu port map(srcA => RD1, srcB => srcB, command => aluCommand, result => WD3, flags => flags);
	--myRam : ram port map (clk  => clk, write_enable => ?, addr => ?, write_data => ?, read_data => ?);
end;
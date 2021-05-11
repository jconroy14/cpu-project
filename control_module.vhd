library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_module is
port(
	clk : in std_logic;
	instruction : in std_logic_vector(31 downto 0);
	aluFlags : in std_logic_vector(3 downto 0);
	op : out std_logic_vector(1 downto 0);
	useImm : out std_logic;
	aluCommand : out std_logic_vector(3 downto 0);
	Rn : out unsigned(3 downto 0); -- address of first operand
	Rd : out unsigned(3 downto 0); -- address of the input register, where the result of Rn and Src2 will be stored
	Rm : out unsigned(3 downto 0); -- address of the second operand (if useImm = 1, use imm12 instead)
	imm : out std_logic_vector(23 downto 0);
	writeToRam : out std_logic;
	writeToReg : out std_logic
);
end; 

architecture synth of control_module is
component decoder is
port(
	instruction : in std_logic_vector(31 downto 0);
	cond : out std_logic_vector(3 downto 0);
	op : out std_logic_vector(1 downto 0);
	useImm : out std_logic;
	aluCommand : out std_logic_vector(3 downto 0);
	Rn : out unsigned(3 downto 0); -- address of first operand
	Rd : out unsigned(3 downto 0); -- address of the input register, where the result of Rn and Src2 will be stored
	Rm : out unsigned(3 downto 0); -- address of the second operand (if useImm = 1, use imm12 instead)
	imm : out std_logic_vector(23 downto 0);
	performLoad : out std_logic;
	FlagWrite : out std_logic
);
end component;

component CPSR is
port(
	clk : in std_logic;
	cpsr_enable : in std_logic_vector(3 downto 0);
	cpsr_in : in std_logic_vector(3 downto 0);
	cpsr_out : out std_logic_vector(3 downto 0)
	
);
end component;

	signal cpsr_enable : std_logic_vector(3 downto 0);
	signal cpsr_out : std_logic_vector(3 downto 0);
	signal FlagWrite, performLoad, useImm_decoded : std_logic;
	signal aluCommand_decoded : std_logic_vector(3 downto 0);
	signal cond : std_logic_vector(3 downto 0);
	
begin
	decode : decoder port map(cond => cond, op => op, instruction => instruction,
							   aluCommand => aluCommand_decoded, Rn => Rn, Rm => Rm,
							   Rd => Rd, useImm => useImm_decoded, imm => imm,
							   performLoad => performLoad, FlagWrite => FlagWrite);
	cpsr_reg : CPSR port map(clk => clk, cpsr_enable => cpsr_enable, cpsr_in => aluFlags, cpsr_out => cpsr_out);
		
	process(all) begin
		case op is
			when "00" =>
				--cond  - shouldn't be exported
				--op  - keep the same
				useImm <= useImm_decoded;
				aluCommand <= aluCommand_decoded;
				--Rn - keep same
				--Rd - keep same
				--Rm - keep same
				--imm12 - keep same
				writeToRam <= '0';
				writeToReg <= '0' when Rd = 4d"15" else '1';
    
				cpsr_enable <= "1111" when (FlagWrite = '1' and -- Case 1: ADD/SUB/RSB
												(aluCommand_decoded = "0010" or
												 aluCommand_decoded = "0011" or
												 aluCommand_decoded = "0100")) else
								"1100" when FlagWrite else -- Case 2: AND/ORR/MOV
								"0000"; -- Case 3: S bit is not set
			when "01" =>
				useImm <= '1';
				aluCommand <= 4b"0100";
				writeToRam <= not(performLoad);
				writeToReg <= performLoad;
				cpsr_enable <= "0000";
			when "10" =>
				useImm <= '1';
				aluCommand <= 4b"0100";
				writeToRam <= '0';
				writeToReg <= '0';
				cpsr_enable <= "0000";
			when others =>
				useImm <= 'X';
				aluCommand <= "XXXX";
				writeToRam <= 'X';
				writeToReg <= 'X';
				cpsr_enable <= "XXXX";
		end case;
	end process;
end;
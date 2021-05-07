library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
port(
	instruction : in std_logic_vector(31 downto 0);
	aluControl : out std_logic_vector(3 downto 0);
	addrA : out unsigned(3 downto 0);
	addrB : out unsigned(3 downto 0);
	addrC : out unsigned(3 downto 0);
	useImm : out std_logic
);
end;

architecture synth of decoder is
signal instr : unsigned(31 downto 0);
begin
	instr <= unsigned(instruction);
	aluControl <= instruction(24 downto 21);
	addrA <= instr(19 downto 16); --Rn, address of first operand
	addrB <= instr(3 downto 0); --Src2, address of second operand (if useImm = 0, otherwise second operand is the imediate value 7 downto 0)
	addrC <= instr(15 downto 12); --Rd, address of the input register, where the result of Rn and Src2 will be stored
	useImm <= instruction(25);
end;
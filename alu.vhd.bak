library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        srcA : in std_logic_vector (31 downto 0);
        srcB : in std_logic_vector (31 downto 0);
        command : in std_logic_vector (3 downto 0);
        result : out std_logic_vector (31 downto 0);
        flags : out std_logic_vector (3 downto 0) -- NZCV
    );
end;

architecture synth of alu is
	signal is_plus_or_minus : std_logic;
	signal arith_full_result : std_logic_vector(32 downto 0);
begin
	is_plus_or_minus <= '1' when (command = "0010" or command = "0011" or command = "0100") else '0';
	flags(3) <= '1' when (result(31) = '1') else '0'; -- Negative flag
	flags(2) <= '1' when (result = 32d"0") else '0'; -- Zero flag
	flags(1) <= '1' when (is_plus_or_minus and arith_full_result(32)) else '0'; -- Carry flag
	flags(0) <= '1' when (is_plus_or_minus and (srcA(31) xnor srcB(31)) and (result(31) xor srcA(31))) else '0'; -- Overflow flag

	process begin
	case command is
		when "0000" => -- Bitwise AND
			result <= srcA and srcB;
		when "0010" => -- Subtraction
			arith_full_result <= std_logic_vector(unsigned(srcA) - unsigned(srcB));
			result <= arith_full_result(31 downto 0);
		when "0011" =>  -- Reverse Subtraction
			arith_full_result <= std_logic_vector(unsigned(srcB) - unsigned(srcA));
			result <= arith_full_result(31 downto 0);
		when "0100" => -- Addition
			arith_full_result <= std_logic_vector(unsigned(srcA) + unsigned(srcB));
			result <= arith_full_result(31 downto 0);
		when "1100" =>  -- Bitwise OR
			result <= srcA or srcB;
		when "1101" => -- MOV. TODO: Figure out how to correctly implement this
			result <= srcB;
		when others =>  -- TODO: Change error checking?
			result <= 32d"0";
	end case;
end process;

end;
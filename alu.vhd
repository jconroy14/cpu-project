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
	signal is_plus, is_minus, is_rev_minus : std_logic;
	signal srcA_33bits, srcB_33bits, result_33bits : std_logic_vector(32 downto 0);
begin
	srcA_33bits <= '0' & srcA;
	srcB_33bits <= '0' & srcB;
	result <= result_33bits (31 downto 0);
	
	is_minus <= '1' when command = "0010" else '0';
	is_rev_minus <= '1' when command = "0011" else '0';
	is_plus <= '1' when command = "0100" else '0';
	
	
	flags(3) <= '1' when (result(31) = '1') else '0'; -- Negative flag
	flags(2) <= '1' when (result = 32d"0") else '0'; -- Zero flag
	flags(1) <= '1' when ((is_plus or is_minus or is_rev_minus) and result_33bits(32)) else '0'; -- Carry flag
	flags(0) <= '1' when ((is_minus and (srcA(31) xor  srcB(31)) and (result(31) xor srcA(31))) or
						  (is_rev_minus and (srcA(31) xor  srcB(31)) and (result(31) xor srcB(31))) or
						  (is_plus and (srcA(31) xnor srcB(31)) and (result(31) xor srcA(31))))
						  else '0'; -- Overflow flag

	process(all) begin
	case command is
		when "0000" => -- Bitwise AND
			result_33bits <= srcA_33bits and srcB_33bits;
		when "0010" => -- Subtraction
			result_33bits <= std_logic_vector(unsigned(srcA_33bits) - unsigned(srcB_33bits));
		when "0011" =>  -- Reverse Subtraction
			result_33bits <= std_logic_vector(unsigned(srcB_33bits) - unsigned(srcA_33bits));
		when "0100" => -- Addition
			result_33bits <= std_logic_vector(unsigned(srcA_33bits) + unsigned(srcB_33bits));
		when "1100" =>  -- Bitwise OR
			result_33bits <= srcA_33bits or srcB_33bits;
		when "1101" => -- MOV. TODO: Figure out how to correctly implement this
			result_33bits <= srcB_33bits;
		when others =>  -- TODO: Change error checking?
			result_33bits <= 33d"0";
	end case;
end process;

end;
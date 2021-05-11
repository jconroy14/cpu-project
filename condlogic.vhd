library IEEE; use IEEE.STD_LOGIC_1164.all;


entity condlogic is -- Conditional logic
	port(
	cond: in STD_LOGIC_VECTOR(3 downto 0);
	flags: in STD_LOGIC_VECTOR(3 downto 0);
	
	doInstruction: out STD_LOGIC);
end;

architecture behave of condlogic is

	signal neg, zero, carry, overflow, ge: STD_LOGIC;
	begin
	(neg, zero, carry, overflow) <= flags;
	ge <= (neg xnor overflow);
	process(all) begin -- Condition checking based on the aluflags
	case Cond is
		when "0000" => doInstruction <= zero; 
		when "0001" => doInstruction <= not zero;
		when "0010" => doInstruction <= carry;
		when "0011" => doInstruction <= not carry;
		when "0100" => doInstruction <= neg;
		when "0101" => doInstruction <= not neg;
		when "0110" => doInstruction <= overflow;
		when "0111" => doInstruction <= not overflow;
		when "1000" => doInstruction <= carry and (not zero);
		when "1001" => doInstruction <= not(carry and (not zero));
		when "1010" => doInstruction <= ge;
		when "1011" => doInstruction <= not ge;
		when "1100" => doInstruction <= (not zero) and ge;
		when "1101" => doInstruction <= not ((not zero) and ge);
		when "1110" => doInstruction <= '1';
		when others => doInstruction <= '-';
	end case;
    end process;
end;
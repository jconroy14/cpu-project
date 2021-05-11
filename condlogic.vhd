library IEEE; use IEEE.STD_LOGIC_1164.all;


entity condlogic is -- Conditional logic
	port(clk, reset: in STD_LOGIC;
	Cond: in STD_LOGIC_VECTOR(3 downto 0);
	ALUFlags: in STD_LOGIC_VECTOR(3 downto 0);
	
	PCS, RegW, MemW: in STD_LOGIC;
	PCSrc, RegWrite: out STD_LOGIC;
	MemWrite: out STD_LOGIC);
	end;
architecture behave of condlogic is

	signal neg, zero, carry, overflow, ge: STD_LOGIC;
	signal Condex: std_logic;
	begin
	(neg, zero, carry, overflow) <= ALUFlags;
	ge <= (neg xnor overflow);
	process(all) begin -- Condition checking based on the aluflags
	case Cond is
		when "0000" => CondEx <= zero; 
		when "0001" => CondEx <= not zero;
		when "0010" => CondEx <= carry;
		when "0011" => CondEx <= not carry;
		when "0100" => CondEx <= neg;
		when "0101" => CondEx <= not neg;
		when "0110" => CondEx <= overflow;
		when "0111" => CondEx <= not overflow;
		when "1000" => CondEx <= carry and (not zero);
		when "1001" => CondEx <= not(carry and (not zero));
		when "1010" => CondEx <= ge;
		when "1011" => CondEx <= not ge;
		when "1100" => CondEx <= (not zero) and ge;
		when "1101" => CondEx <= not ((not zero) and ge);
		when "1110" => CondEx <= '1';
		when others => CondEx <= '-';
		
		
		
		end case;
		
		RegWrite <= RegW and CondEx;
        MemWrite <= MemW and CondEx;
		PCSrc <= PCS and CondEx;
    end process;
end;
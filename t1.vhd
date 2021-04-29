library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regtest is 

end regtest;

architecture test of regtest is 
component regfile 
port(
clk: in std_logic;
A1: in unsigned(3 downto 0); --address for port 1 
A2: in unsigned(3 downto 0); -- address for port 2 
A3: in unsigned(3 downto 0); --Addres for port 3
WE3 : in std_logic; --write enable for port 3
R15: in std_logic_vector(31 downto 0); -- Passthrouhg for PC+8
RD1: out std_logic_vector(31 downto 0); -- Data result for port 1
RD2: out std_logic_vector(31 downto 0); -- data result for port 2
WD3: in std_logic_vector(31 downto 0) -- Data input for port 3
);
end component;
signal clk: std_logic := '1';
signal WE3:  std_logic := '1';
signal A1,A2,A3:  unsigned(3 downto 0):= "0000"; --Addres for port 3
 --write enable for port 3
signal R15,RD1,RD2,WD3: std_logic_vector(31 downto 0) := (others => '0');

begin 
reg: regfile port map(clk,A1,A2,A3, WE3,R15,RD1,RD2,WD3);

	process begin
		for r in 0 to 2147483647 loop --Largest possible value for 32 bits 
		    WD3 <= std_logic_vector(to_unsigned(r,WD3'length));
			
			for k in 0 to 14 loop 
				clk <= '1';
				WE3 <= '1';
				
						
				
				A3 <= to_unsigned(k,A3'length);
				if (k > 2) then 
				   A1 <= to_unsigned(k-2, A1'length);
				   A2 <= to_unsigned(k-1, A2'length);
				   
				else
				   A1 <= to_unsigned(0, A1'length);
				   A2 <= to_unsigned(0, A2'length);			
			   end if; 
			
			   
			   wait for 1 sec;
			   clk <= '0';
			   wait for 1 sec;
			   if (k > 2) then 
					if RD1 /= std_logic_vector(to_unsigned(r, WD3'length)) or RD2 /=std_logic_vector(to_unsigned(r, WD3'length)) then 

						report "failed: "& integer'image(to_integer(unsigned(RD2))) ;--& " and integer: " & integer'image(k);
					
					end if;
					
				report "success read: RD1- "& integer'image(to_integer(unsigned(RD1))) & " RD2 - " &integer'image(to_integer(unsigned(RD1))); 
			   
			 
				end if;
			   
			end loop;
		
			  
				 
			  
		end loop;
		wait;  
	end process; 

end test;
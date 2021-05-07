library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
    port(
        clk          : in std_logic;
        write_enable : in std_logic;
        addr         : in unsigned (31 downto 0);
        write_data   : in unsigned (31 downto 0);
        read_data    : out unsigned (31 downto 0)
    );
end;

architecture synth of ram is
    constant ram_depth : natural := 16; --words available in RAM
	constant ram_addr_size : natural := 4; --bits needed to specify a RAM address
    constant ram_width : natural := 32; --bits in a word
 
    type ram_type is array (0 to ram_depth - 1)
        of unsigned(ram_width - 1 downto 0);
  
    signal memory: ram_type;
	signal word_addr: natural;
begin
	word_addr <= to_integer(addr(31 downto 2)); -- Divide by 4 to convert from byte-address to word-address
	read_data <= memory(word_addr) when word_addr < ram_depth else "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
	
	process(clk) begin
		if rising_edge(clk) then
			if (write_enable = '1') and (word_addr < ram_depth) then
				memory(word_addr) <= write_data;
			end if;
		end if;
	end process;

end;
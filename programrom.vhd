library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
	
use std.textio.all;

entity progrom is
	port(
	addr : in unsigned(31 downto 0);
	data : out std_logic_vector(31 downto 0)
	);
end;




architecture synth of progrom is 
constant rom_depth : natural := 12;
constant rom_width : natural := 32;
 
type rom_type is array (0 to rom_depth - 1)
  of std_logic_vector(rom_width - 1 downto 0);
  
  signal storage: rom_type;

--impure function init_rom_hex return rom_type is

	impure function init_rom_hex return rom_type is
  file text_file : text open read_mode is "Rommy.txt";
  variable text_line : line;
  variable rom_content : rom_type;
  variable bv : bit_vector(rom_content(0)'range);
begin
  for i in 0 to rom_depth - 1 loop
    readline(text_file, text_line);
    read(text_line, bv);
    rom_content(i) := To_StdLogicVector(bv);
  end loop;
 
  return rom_content;
end function;

begin 

storage <=init_rom_hex;

  data <= storage(to_integer(addr));

end;

	


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
  file text_file : text open read_mode is "rom_content_hex.txt";
  variable text_line : line;
  variable rom_content : rom_type;
  variable c : character;
  variable offset : integer;
  variable hex_val : std_logic_vector(3 downto 0);
begin
  for i in 0 to rom_depth - 1 loop
    readline(text_file, text_line);
 
    offset := 0;
 
    while offset < rom_content(i)'high loop
      read(text_line, c);
 
      case c is
        when '0' => hex_val := "0000";
        when '1' => hex_val := "0001";
        when '2' => hex_val := "0010";
        when '3' => hex_val := "0011";
        when '4' => hex_val := "0100";
        when '5' => hex_val := "0101";
        when '6' => hex_val := "0110";
        when '7' => hex_val := "0111";
        when '8' => hex_val := "1000";
        when '9' => hex_val := "1001";
        when 'A' | 'a' => hex_val := "1010";
        when 'B' | 'b' => hex_val := "1011";
        when 'C' | 'c' => hex_val := "1100";
        when 'D' | 'd' => hex_val := "1101";
        when 'E' | 'e' => hex_val := "1110";
        when 'F' | 'f' => hex_val := "1111";
 
        when others =>
          hex_val := "XXXX";
          assert false report "Found non-hex character '" & c & "'";
      end case;
 
      rom_content(i)(rom_content(i)'high - offset
        downto rom_content(i)'high - offset - 3) := hex_val;
      offset := offset + 4;
 
    end loop;
  end loop;
 
  return rom_content;
end function;


begin 

storage <=init_rom_hex;

  data <= storage(to_integer(addr));

end;
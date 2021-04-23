library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity regfile is 
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
end;

architecture synth of regfile is 
type regarray is array (7 downto 0) of std_logic_vector(31 downto 0);
signal mem: regarray;

begin 
    process(clk) begin
        if rising_edge(clk) then
           if WE3='1' then 
                mem(TO_INTEGER(A3)) <= WD3;
            end if ;
            if (A1 /= "1111") then  --All the port is not 15
                  RD1 <= mem(to_integer(A1));
            else 
                RD2 <= R15;
            end if ;
            if (A2 /= "1111") then  --All the port is not 15 
                  RD2 <= mem(to_integer(A2));
            else 
                RD2 <= R15;
            end if ;
		end if;
            
            

    end process;

  
              
end;
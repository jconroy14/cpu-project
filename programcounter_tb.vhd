library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end;

architecture sim of testbench is

component programcounter is
port(
	clk : in std_logic;
	reset : in std_logic;
	branch : in std_logic;
	branchAddr : in std_logic_vector (31 downto 0);
	pc : out unsigned (31 downto 0)
);
end component;

signal clk : std_logic;
signal reset : std_logic;
signal branch : std_logic;
signal branchAddr : std_logic_vector (31 downto 0);
signal pc : unsigned (31 downto 0);

begin

	dut : programcounter port map (clk => clk, reset => reset, branch => branch, branchAddr => branchAddr, pc => pc);

	process begin
		reset <= '1'; clk <= '1'; branch <= '1';  branchAddr <= 32x"00000000"; wait for 10 ns;
		wait;
	end process;
end;
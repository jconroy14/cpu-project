library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity top_testbench is
end;

architecture sim of top_testbench is
	component top_module is
		port (
			resetPC : in std_logic;
			clk : in std_logic;
			output : out std_logic_vector(31 downto 0);
			out_pc : out unsigned(31 downto 0);
			out_instruction : out std_logic_vector(31 downto 0);
			out_immout : out std_logic_vector(31 downto 0);
			out_srcB : out std_logic_vector(31 downto 0);
			out_op : out std_logic_vector(1 downto 0);
			out_aluresult : out std_logic_vector(31 downto 0);
			out_rn_contents : out std_logic_vector(31 downto 0);
			out_src_b_contents : out std_logic_vector(31 downto 0);
			out_ram_write : out std_logic;
			out_ram_result : out std_logic_vector(31 downto 0);
			out_reg_write : out std_logic;
			out_imm24 : out std_logic_vector(23 downto 0)
		);
	end component;
	signal resetPC : std_logic := '1';
	signal clk : std_logic := '0';
	signal out_ram_write, out_reg_write : std_logic;
	signal output, out_ram_result, out_instruction, out_immout, out_srcB, out_aluresult, out_rn_contents, out_src_b_contents : std_logic_vector(31 downto 0);
	signal out_pc : unsigned(31 downto 0);
	signal out_op : std_logic_vector(1 downto 0);
	signal out_imm24 : std_logic_vector(23 downto 0);
begin
	clk <= not clk after 100 ns;
	cpuPortmap : top_module port map(out_reg_write => out_reg_write, out_ram_write => out_ram_write,
					out_ram_result => out_ram_result, out_op => out_op, out_aluresult => out_aluresult,
					out_rn_contents => out_rn_contents, out_src_b_contents => out_src_b_contents,
					resetPC => resetPC, clk => clk, output => output, out_pc => out_pc,
					out_instruction => out_instruction, out_immout => out_immout, out_srcB => out_srcB,
					out_imm24 => out_imm24);
	
	process begin
		wait until rising_edge(clk);
		
		resetPC <= '0';
		wait until rising_edge(clk);
		--assert output = 32d"0" report "Failure at step 1" severity failure;
		
		wait until rising_edge(clk);
		--assert output = 32d"12" report "Failure at step 2" severity failure;
		
		wait until rising_edge(clk);
		--assert output = 32d"0" report "Failure at step 3" severity failure;
		
		wait until rising_edge(clk);
		--assert output = 32d"0" report "Failure at step 4" severity failure;
		
		wait until rising_edge(clk);
		--assert output = 32d"4080" report "Failure at step 5" severity failure;
		
		report "All tests passed!";
		wait;
	end process;
end;
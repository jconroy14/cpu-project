library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity ram_testbench is
end;

architecture sim of ram_testbench is
	component ram is
    port(
        clk          : in std_logic;
        write_enable : in std_logic;
        addr         : in unsigned (31 downto 0);
        write_data   : in unsigned (31 downto 0);
        read_data    : out unsigned (31 downto 0)
    );
	end component;
	
	signal clk, write_enable : std_logic := '0';
	signal addr, write_data, read_data : unsigned (31 downto 0) := 32d"0";

begin
	dut : ram port map(clk, write_enable, addr, write_data, read_data);
	clk <= not clk after 5 ns;
	
	process begin
		write_enable <= '1';
		addr <= 32d"0";
		write_data <= 32d"15";
		wait until rising_edge(clk);
		
		write_enable <= '1';
		addr <= 32d"4";
		write_data <= 32d"20";
		wait until rising_edge(clk);
		
		write_enable <= '1';
		addr <= 32d"12";
		write_data <= 32d"52435";
		wait until rising_edge(clk);

		write_enable <= '0';
		addr <= 32d"0";
		wait until rising_edge(clk);
		assert (read_data = 32d"15") report "Test 1 failed";
		
		write_enable <= '0';
		addr <= 32d"12";
		wait until rising_edge(clk);
		assert (read_data = 32d"52435") report "Test 2 failed";
		
		write_enable <= '0';
		addr <= 32d"8";
		wait until rising_edge(clk);
		assert Is_X(read_data) report "Test 3 failed";
		
		write_enable <= '1';
		addr <= 32d"8";
		write_data <= 32d"8";
		wait until rising_edge(clk);
		
		write_enable <= '0';
		addr <= 32d"8";
		wait until rising_edge(clk);
		assert (read_data = 32d"8") report "Test 4 failed";
		
		write_enable <= '0';
		addr <= 32d"4";
		wait until rising_edge(clk);
		assert (read_data = 32d"20") report "Test 5 failed";
		
		write_enable <= '0';
		addr <= 32d"16";
		wait until rising_edge(clk);
		assert Is_X(read_data) report "Test 6 failed";
		
		write_enable <= '1';
		addr <= 32d"16";
		wait until rising_edge(clk);
		
		write_enable <= '0';
		addr <= 32d"164";
		wait until rising_edge(clk);
		assert Is_X(read_data) report "Test 7 failed";
		
		write_enable <= '1';
		addr <= 32d"162";
		wait until rising_edge(clk);
		
		write(output, "All tests passed!" & LF);
		wait;
	end process;
	
	
	
end;
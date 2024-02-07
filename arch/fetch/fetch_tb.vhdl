library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity fetch_tb is
end fetch_tb;

architecture fetch_tb_module of fetch_tb is

component fetch IS
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			PC_load	:	in std_logic;
			PC_jump	:	in std_logic_vector(7 downto 0);
			PC_out	:	out std_logic_vector(7 downto 0)
			);
end component;

signal sr_en : std_logic := '0';
signal sr_clk : std_logic  := '0';
signal sr_rst : std_logic;
signal sr_PC_load : std_logic;
signal sr_PC_jump : std_logic_vector (7 downto 0);
signal sr_PC_out : std_logic_vector (7 downto 0);

begin

sr_clk <= not sr_clk after 7 ns;
fetch_test : fetch
port map (
  en => sr_en,
	clk => sr_clk,
	rst => sr_rst,
	PC_load => sr_PC_load,
	PC_jump => sr_PC_jump,
	PC_out => sr_PC_out
);

process
begin

sr_en <= '1';
sr_PC_load <= '1';
sr_PC_jump <= "00000111";

wait until rising_edge(sr_clk);

sr_PC_load <= '0';

wait until rising_edge(sr_clk);
wait until rising_edge(sr_clk);
wait until rising_edge(sr_clk);
end process;
end architecture;


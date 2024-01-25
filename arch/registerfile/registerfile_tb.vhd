library ieee;
library work;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity tb_Module is 
end tb_Module;

architecture archi_tb_Module of tb_Module is

COMPONENT RegFile
	PORT (rst : in std_logic;
	clk : in std_logic;
	addr : in std_logic_vector (2 downto 0);
	en : in std_logic;
	w : in std_logic_vector (15 downto 0);
	addrB : in std_logic_vector (2 downto 0);
	addrA : in std_logic_vector (2 downto 0);
	outA : out std_logic_vector (15 downto 0);
	outB : out std_logic_vector (15 downto 0)
	);
END COMPONENT;


signal sr_rst : std_logic := '0';
signal sr_clk : std_logic := '0';
signal sr_addr : std_logic_vector (2 downto 0);
signal sr_en : std_logic;
signal sr_w : std_logic_vector (15 downto 0);
signal sr_addrB : std_logic_vector (2 downto 0);
signal sr_addrA : std_logic_vector (2 downto 0);
signal sr_outA : std_logic_vector (15 downto 0);
signal sr_outB : std_logic_vector (15 downto 0);

begin
 
sr_clk <= not sr_clk after 7 ns;

regi : RegFile
port map(
	rst => sr_rst,
	clk => sr_clk,
	addr => sr_addr,
	en => sr_en,
	w => sr_w,
	addrB => sr_addrB,
	addrA => sr_addrA,
	outA => sr_outA,
	outB => sr_outB
);
sr_rst <= '1', '0' after 4000 ps;

process
begin
	wait until rising_edge(sr_clk);
	sr_en <= '1';
	sr_addr <= "010";
	sr_w <= "1111111111111111";
	wait until rising_edge(sr_clk);
	sr_en <= '0';
	sr_addrA <= "001";
	sr_addrB <= "100";
	wait until rising_edge(sr_clk);
	sr_en <= '1';
	sr_addr <= "001";
	sr_w <= "0000000000000001";
	wait until rising_edge(sr_clk);
	sr_en <= '0';
	sr_addrA <= "001";
	sr_addrB <= "100";
	wait until rising_edge(sr_clk);

end process;

end architecture archi_tb_Module;
	
	

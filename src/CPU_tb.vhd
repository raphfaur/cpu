library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
use std.textio.all;

entity cpu_tb is 
end entity;

architecture cpu_tb_module of cpu_tb is


COMPONENT CPU
	PORT
	(
		MAX10_CLK1_50 :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
    RUN : in std_logic;
    RST : in std_logic
	);
END component;

signal sr_MAX10_CLK1_50 : STD_LOGIC := '0';
signal sr_SW : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal sr_HEX0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal sr_HEX1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal sr_HEX2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal sr_HEX3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal sr_HEX4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal sr_HEX5 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal sr_LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal sr_RUN : std_logic;		
signal sr_RST : std_logic;		

begin

cpu_runner : cpu
port map(
MAX10_CLK1_50 => sr_MAX10_CLK1_50, 
SW => sr_SW, 
HEX0 => sr_HEX0, 
HEX1 => sr_HEX1, 
HEX2 => sr_HEX2, 
HEX3 => sr_HEX3, 
HEX4 => sr_HEX4, 
HEX5 => sr_HEX5, 
LEDR => sr_LEDR,
RUN => sr_RUN,
RST => sr_RST
);

sr_MAX10_CLK1_50 <= not sr_MAX10_CLK1_50 after 10 ns;
sr_RUN <= '1'; 
sr_RST <= '1', '0' after 3 ns;

run: process
begin
  wait until rising_edge(sr_MAX10_CLK1_50);
end process run;

end architecture cpu_tb_module;

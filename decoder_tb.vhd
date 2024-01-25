library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity decoder_tb is
end decoder_tb;

architecture decoder_tb_module of decoder_tb is

component decoder IS 
	PORT(clk : in std_logic;
	bytecode : in std_logic_vector(31 downto 0);
	addrDest : out std_logic_vector (2 downto 0);
	en : out std_logic;
	addrRA : out std_logic_vector (2 downto 0);
	addrRB : out std_logic_vector (2 downto 0);
	op_A : out std_logic;
	op_B : out std_logic;
	opcode_out : out std_logic_vector(2 downto 0)
);

end component;

signal sr_clk : std_logic := '0';
signal sr_bytecode : std_logic_vector(31 downto 0);
signal sr_addrDest : std_logic_vector (2 downto 0);
signal sr_en : std_logic;
signal sr_addrRA : std_logic_vector (2 downto 0);
signal sr_addrRB : std_logic_vector (2 downto 0);
signal sr_op_A : std_logic;
signal sr_op_B : std_logic;
signal sr_opcode_out : std_logic_vector(2 downto 0);

begin

sr_clk <= not sr_clk after 7ns;

decoder_test : decoder
port map (
	clk => sr_clk,
	bytecode => sr_bytecode,
	addrDest => sr_addrDest,
	en => sr_en,
	addrRA => sr_addrRA,
	addrRB => sr_addrRB,
	op_A => sr_op_A,
	op_B => sr_op_B,
	opcode_out => sr_opcode_out
);

process
begin

sr_bytecode <= "00000011001010000000000000000000";

wait until rising_edge(sr_clk);

end process;
end architecture;


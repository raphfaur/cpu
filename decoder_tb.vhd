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
	en_reg : out std_logic;
  en_fetch : out std_logic;
	fetch_jmp : out std_logic_vector(7 downto 0);
  fetch_load : out std_logic;
  addrRA : out std_logic_vector (2 downto 0);
	addrRB : out std_logic_vector (2 downto 0);
  immA : out std_logic_vector(15 downto 0);
  immB : out std_logic_vector(15 downto 0);
	op_A : out std_logic;
	op_B : out std_logic;
	opcode_out : out std_logic_vector(2 downto 0)
);

end component;

signal sr_clk : std_logic := '0';
signal sr_bytecode : std_logic_vector(31 downto 0);
signal sr_addrDest : std_logic_vector (2 downto 0);
signal sr_en_reg : std_logic;
signal sr_en_fetch : std_logic;
signal sr_fetch_load : std_logic;
signal sr_fetch_jmp : std_logic_vector(7 downto 0);
signal sr_addrRA : std_logic_vector (2 downto 0);
signal sr_addrRB : std_logic_vector (2 downto 0);
signal sr_immB : std_logic_vector (15 downto 0);
signal sr_immA : std_logic_vector (15 downto 0);
signal sr_op_A : std_logic;
signal sr_op_B : std_logic;
signal sr_opcode_out : std_logic_vector(2 downto 0);

begin

sr_clk <= not sr_clk after 7 ns;

decoder_test : decoder
port map (
	clk => sr_clk,
	bytecode => sr_bytecode,
	addrDest => sr_addrDest,
	en_reg => sr_en_reg,
  en_fetch => sr_en_fetch,
  fetch_load => sr_fetch_load,
  fetch_jmp => sr_fetch_jmp,
	addrRA => sr_addrRA,
	addrRB => sr_addrRB,
  immA => sr_immA,
  immB => sr_immB,
	op_A => sr_op_A,
	op_B => sr_op_B,
	opcode_out => sr_opcode_out
);

process
begin

sr_bytecode <= "00000011001010000000000000000000";

wait until rising_edge(sr_clk);

-- ADD R1 + 0000000000000011 => R2
sr_bytecode <= "01000010001000000000000001100000";

wait until rising_edge(sr_clk);

end process;
end architecture;


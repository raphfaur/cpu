library ieee;
USE ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

LIBRARY work;

entity alu is 
PORT(
  reg_in_A : in std_logic_vector (15 downto 0);
	reg_in_B : in std_logic_vector (15 downto 0);
	imm_in_A : in std_logic_vector (15 downto 0);
	imm_in_B : in std_logic_vector (15 downto 0); 
	op_A : in std_logic;
	op_B : in std_logic;
	-- Zero flag
	zf : out std_logic;
	-- Overflow flag
	ovf : out std_logic;
	output : out std_logic_vector (15 downto 0);
	op : in std_logic_vector (2 downto 0)
);

end alu;

architecture alu_b of alu is 


signal tmp_a : std_logic_vector (15 downto 0);
signal tmp_b : std_logic_vector (15 downto 0);
signal tmp_output : std_logic_vector (15 downto 0);

begin



tmp_a <= reg_in_A when op_A = '0' else
	imm_in_A when op_A = '1' else
	(others => '0');

tmp_b <= reg_in_B when op_B = '0' else
	imm_in_B when op_B = '1' else
	(others => '0');

	
tmp_output <= std_logic_vector(signed(tmp_A) + signed(tmp_B)) when op = "000" else
	std_logic_vector(signed(tmp_A) - signed(tmp_B)) when op = "001" else
	std_logic_vector(shift_right(unsigned(tmp_B), to_integer(unsigned(tmp_A)))) when op = "010" else
	std_logic_vector(shift_left(unsigned(tmp_B), to_integer(unsigned(tmp_A)))) when op = "011" else
	tmp_A and tmp_B when op = "100" else
	tmp_A or tmp_B when op = "101" else
	tmp_A xor tmp_B when op = "110" else
	(others => '1');


output <= tmp_output;
	
zf <= '1' when tmp_output = "0000000000000000" else 
	'0';


end architecture;
		
	

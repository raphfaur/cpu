library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity alu_tb is
end alu_tb;

architecture alu_tb_module of alu_tb is

component alu is 
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

end component;

signal sr_clk : std_logic := '0';
signal sr_reg_in_A : std_logic_vector (15 downto 0);
signal sr_reg_in_B : std_logic_vector (15 downto 0);
signal sr_imm_in_A : std_logic_vector (15 downto 0);
signal sr_imm_in_B : std_logic_vector (15 downto 0); 
signal sr_op_A : std_logic;
signal sr_op_B : std_logic;
-- Zero flag
signal sr_zf : std_logic;
-- Overflow flag
signal sr_ovf : std_logic;
signal sr_output : std_logic_vector (15 downto 0);
signal sr_op : std_logic_vector (2 downto 0);

begin

sr_clk <= not sr_clk after 7 ns;

alu1 :  alu
port map (
	reg_in_A => sr_reg_in_A,
	reg_in_B => sr_reg_in_B,
	imm_in_A => sr_imm_in_A,
	imm_in_B => sr_imm_in_B, 
	op_A => sr_op_A,
	op_B => sr_op_B,
	zf => sr_zf,
	ovf => sr_ovf,
	output => sr_output,
	op => sr_op
);


process 
begin

sr_imm_in_A <= "0000000000000001";
sr_imm_in_B <= "0000000000000001";
sr_op_A <= '1';
sr_op_B <= '1';
sr_op <= "000";

wait until rising_edge(sr_clk);

sr_imm_in_A <= "0000000000000001";
sr_imm_in_B <= "0000000000000011";
sr_op_A <= '1';
sr_op_B <= '1';
sr_op <= "001";

wait until rising_edge(sr_clk);



end process;
end architecture;

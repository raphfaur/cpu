library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

entity no_fetch_tb is 
end entity;

architecture no_fetch_tb_module is
begin

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

-- Decoder signals
signal sr_clk : std_logic := '0';
signal sr_bytecode : std_logic_vector(31 downto 0);
signal sr_addrDest : std_logic_vector (2 downto 0);
signal sr_en : std_logic;
signal sr_addrRA : std_logic_vector (2 downto 0);
signal sr_addrRB : std_logic_vector (2 downto 0);
signal sr_op_A : std_logic;
signal sr_op_B : std_logic;
signal sr_opcode_out : std_logic_vector(2 downto 0);

-- Register file signals
signal sr_rst : std_logic := '0';
signal sr_addr : std_logic_vector (2 downto 0);
signal sr_en : std_logic;
signal sr_w : std_logic_vector (15 downto 0);
signal sr_addrB : std_logic_vector (2 downto 0);
signal sr_addrA : std_logic_vector (2 downto 0);
signal sr_outA : std_logic_vector (15 downto 0);
signal sr_outB : std_logic_vector (15 downto 0);

-- Alu signals
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


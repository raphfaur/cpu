-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"
-- CREATED		"Tue Jan 12 09:49:06 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY CPU IS 
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
END CPU;
  
ARCHITECTURE bdf_type OF CPU IS 


-- Regfile 

COMPONENT RegFile
	PORT (
  rst : in std_logic;
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

-- Fetch
component Fetch IS
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			PC_load	:	in std_logic;
			PC_jump	:	in std_logic_vector(7 downto 0);
			PC_out	:	out std_logic_vector(7 downto 0);
      ram_en : out std_logic;
      ram_rw : out std_logic
			);
end component;

-- Decoder

COMPONENT Decoder 
	PORT(
  rst : in std_logic;
  clk : in std_logic;
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
end COMPONENT;

-- ALU

COMPONENT Alu is 
PORT(
  reg_in_A : in std_logic_vector (15 downto 0);
	reg_in_B : in std_logic_vector (15 downto 0);
	imm_in_A : in std_logic_vector (15 downto 0);
	imm_in_B : in std_logic_vector (15 downto 0); 
	op_A : in std_logic;
	op_B : in std_logic;
	-- Zero flag
	zf : out std_logic;
	output : out std_logic_vector (15 downto 0);
	op : in std_logic_vector (2 downto 0)
);
end COMPONENT;

-- ram

COMPONENT ram is
	port(
			rw,en		:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_in	:	in std_logic_vector(31 downto 0);
			Data_out:	out std_logic_vector(31 downto 0)
			);
end COMPONENT;

COMPONENT seg7_lut
	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dig2dec
	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

-- Fetch signals

signal fetch_sr_en : std_logic;
signal fetch_sr_clk : std_logic  := '0';
signal fetch_sr_rst : std_logic;
signal fetch_sr_PC_load : std_logic;
signal fetch_sr_PC_jump : std_logic_vector (7 downto 0);
signal fetch_sr_PC_out : std_logic_vector (7 downto 0);
signal fetch_sr_ram_en : std_logic;
signal fetch_sr_ram_rw : std_logic;


-- ram signal

signal ram_sr_rw : std_logic;
signal ram_sr_en : std_logic;
signal ram_sr_clk :	std_logic;
signal ram_sr_rst :	std_logic;
signal ram_sr_Adress :	std_logic_vector(7 downto 0);
signal ram_sr_Data_in :	std_logic_vector(31 downto 0);
signal ram_sr_Data_out :	std_logic_vector(31 downto 0);

-- Decoder signals

signal decoder_sr_clk : std_logic;
signal decoder_sr_rst : std_logic;
signal decoder_sr_bytecode : std_logic_vector(31 downto 0);
signal decoder_sr_addrDest : std_logic_vector (2 downto 0);
signal decoder_sr_en_reg : std_logic;
signal decoder_sr_en_fetch : std_logic;
signal decoder_sr_fetch_jmp : std_logic_vector(7 downto 0);
signal decoder_sr_fetch_load : std_logic;
signal decoder_sr_addrRA : std_logic_vector (2 downto 0);
signal decoder_sr_addrRB : std_logic_vector (2 downto 0);
signal decoder_sr_immA : std_logic_vector(15 downto 0);
signal decoder_sr_immB : std_logic_vector(15 downto 0);
signal decoder_sr_op_A : std_logic;
signal decoder_sr_op_B : std_logic;
signal decoder_sr_opcode_out : std_logic_vector(2 downto 0);

-- Register file signals

signal regfile_sr_rst : std_logic;
signal regfile_sr_clk : std_logic;
signal regfile_sr_addr : std_logic_vector (2 downto 0);
signal regfile_sr_en : std_logic;
signal regfile_sr_w : std_logic_vector (15 downto 0);
signal regfile_sr_addrB : std_logic_vector (2 downto 0);
signal regfile_sr_addrA : std_logic_vector (2 downto 0);
signal regfile_sr_outA : std_logic_vector (15 downto 0);
signal regfile_sr_outB : std_logic_vector (15 downto 0);

-- Alu signals

signal alu_sr_reg_in_A : std_logic_vector (15 downto 0);
signal alu_sr_reg_in_B : std_logic_vector (15 downto 0);
signal alu_sr_imm_in_A : std_logic_vector (15 downto 0);
signal alu_sr_imm_in_B : std_logic_vector (15 downto 0); 
signal alu_sr_op_A : std_logic;
signal alu_sr_op_B : std_logic;
signal alu_sr_zf : std_logic;
signal alu_sr_output : std_logic_vector (15 downto 0);
signal alu_sr_op : std_logic_vector (2 downto 0);


SIGNAL	zero :  STD_LOGIC;
SIGNAL	one :  STD_LOGIC;
SIGNAL	HEX_out0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out2 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	HEX_out3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	seg7_in0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 

-- Connect clk and reset

fetch_sr_rst <= RST;
decoder_sr_rst <= RST;
ram_sr_rst <= RST;
regfile_sr_rst <= RST;

regfile_sr_clk <= MAX10_CLK1_50;
ram_sr_clk <= MAX10_CLK1_50;
fetch_sr_clk <= MAX10_CLK1_50;
decoder_sr_clk <= MAX10_CLK1_50;

-- Connect ram and Fetch

ram_sr_en <= fetch_sr_ram_en;
ram_sr_rw <= fetch_sr_ram_rw;
ram_sr_Adress <= fetch_sr_PC_out;

-- Connect ram and decoder

decoder_sr_bytecode <= ram_sr_Data_out;

-- Connect decoder and regfile

regfile_sr_en <= decoder_sr_en_reg;
regfile_sr_addrA <= decoder_sr_addrRA;
regfile_sr_addrB <= decoder_sr_addrRB;
regfile_sr_addr <= decoder_sr_addrDest;

-- Connect ALU

alu_sr_reg_in_A <= regfile_sr_outA;
alu_sr_reg_in_B <= regfile_sr_outB;

alu_sr_imm_in_A <= decoder_sr_immA;
alu_sr_imm_in_B <= decoder_sr_immB;


alu_sr_op_A <= decoder_sr_op_A;
alu_sr_op_B <= decoder_sr_op_B;
alu_sr_op <= decoder_sr_opcode_out;

regfile_sr_w <= alu_sr_output;

-- Connect RUN and fetch enable in order to be able to pause the cpu fetching

fetch_sr_en <= RUN;

-- Connect Decoder and Fetch
fetch_sr_PC_load <= decoder_sr_fetch_load;
fetch_sr_PC_jump <= decoder_sr_fetch_jmp;

-- Map fetch

fetch_stage : fetch
port map (
en => fetch_sr_en ,
clk => fetch_sr_clk ,
rst => fetch_sr_rst ,
PC_load => fetch_sr_PC_load ,
PC_jump => fetch_sr_PC_jump ,
PC_out => fetch_sr_PC_out,
ram_en => fetch_sr_ram_en,
ram_rw => fetch_sr_ram_rw
);

-- Map RAM

ram_st : ram
port map (
rw => ram_sr_rw ,
en => ram_sr_en ,
clk => ram_sr_clk ,
rst => ram_sr_rst ,
Adress => ram_sr_Adress ,
Data_in => ram_sr_Data_in ,
Data_out => ram_sr_Data_out
);

-- Map decoder

decoder_stage : decoder
port map
(
clk => decoder_sr_clk,
rst => decoder_sr_rst,
bytecode => decoder_sr_bytecode  ,
addrDest => decoder_sr_addrDest,
en_reg => decoder_sr_en_reg,
en_fetch => decoder_sr_en_fetch,
fetch_jmp => decoder_sr_fetch_jmp,
fetch_load => decoder_sr_fetch_load,
addrRA => decoder_sr_addrRA,
addrRB => decoder_sr_addrRB,
immA => decoder_sr_immA,
immB => decoder_sr_immB,
op_A => decoder_sr_op_A,
op_B => decoder_sr_op_B,
opcode_out => decoder_sr_opcode_out
);

regi : RegFile
port map(
  rst => regfile_sr_rst,
	clk => regfile_sr_clk,
	addr => regfile_sr_addr,
	en => regfile_sr_en,
	w => regfile_sr_w,
	addrB => regfile_sr_addrB,
	addrA => regfile_sr_addrA,
	outA => regfile_sr_outA,
	outB => regfile_sr_outB
);

-- Map ALU

exec_stage : alu
port map(
reg_in_A => alu_sr_reg_in_A ,
reg_in_B => alu_sr_reg_in_B ,
imm_in_A => alu_sr_imm_in_A ,
imm_in_B => alu_sr_imm_in_B , 
op_A => alu_sr_op_A ,
op_B => alu_sr_op_B ,
zf => alu_sr_zf ,
output => alu_sr_output ,
op => alu_sr_op
);

-- b2v_inst : seg7_lut
-- PORT MAP(iDIG => seg7_in0,
-- 		 oSEG => HEX_out4(6 DOWNTO 0));
-- 
-- 
-- b2v_inst1 : seg7_lut
-- PORT MAP(iDIG => seg7_in1,
-- 		 oSEG => HEX_out3(6 DOWNTO 0));
-- 
-- 
-- b2v_inst2 : seg7_lut
-- PORT MAP(iDIG => seg7_in2,
-- 		 oSEG => HEX_out2(6 DOWNTO 0));
-- 
-- 
-- b2v_inst3 : seg7_lut
-- PORT MAP(iDIG => seg7_in3,
-- 		 oSEG => HEX_out1(6 DOWNTO 0));
-- 
-- 
-- b2v_inst4 : seg7_lut
-- PORT MAP(iDIG => seg7_in4,
-- 		 oSEG => HEX_out0(6 DOWNTO 0));
-- 
-- 
-- b2v_inst5 : dig2dec
-- PORT MAP(		 vol => "0000000000000001",
-- 		 seg0 => seg7_in4,
-- 		 seg1 => seg7_in3,
-- 		 seg2 => seg7_in2,
-- 		 seg3 => seg7_in1,
-- 		 seg4 => seg7_in0);
-- 
-- HEX0 <= HEX_out0;
-- HEX1 <= HEX_out1;
-- HEX2 <= HEX_out2;
-- HEX3 <= HEX_out3;
-- HEX4 <= HEX_out4;
-- HEX5(7) <= one;
-- HEX5(6) <= one;
-- HEX5(5) <= one;
-- HEX5(4) <= one;
-- HEX5(3) <= one;
-- HEX5(2) <= one;
-- HEX5(1) <= one;
-- HEX5(0) <= one;
-- 
-- -- zero <= '0';
-- -- one <= '1';
-- -- HEX_out0(7) <= '1';
-- -- HEX_out1(7) <= '1';
-- -- HEX_out2(7) <= '1';
-- -- HEX_out3(7) <= '1';
-- -- HEX_out4(7) <= '1';
-- 
-- 
LEDR <= SW;

END bdf_type;

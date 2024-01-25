LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

	
ENTITY DECODER IS 
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

end DECODER;

architecture decoder1 of DECODER is 

begin

process (clk)
variable opcode : std_logic_vector(5 downto 0);
variable format : std_logic_vector(1 downto 0);
variable op : std_logic_vector(2 downto 0);
variable rdest : std_logic_vector(2 downto 0);
variable ra : std_logic_vector(2 downto 0);
variable rb : std_logic_vector(2 downto 0);
variable imm : std_logic_vector(15 downto 0);

begin
if rising_edge(clk) then
format := bytecode(31 downto 30);
op := bytecode(29 downto 27);

case format is
	when "00" =>
		rdest := bytecode(26 downto 24);
		ra := bytecode(23 downto 21);
		rb := bytecode(20 downto 18);
		
		op_a <= '0';
		op_b <= '0';
		
		
		addrRA <= ra;
		addrRB <= rb;
		addrDest <= rdest;
		
		en <= '1';
		
		opcode_out <= op;
	when others =>
		null;
end case;
end if;

end process;
end architecture;



LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

	
ENTITY DECODER IS 
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
    -- Get registers address
		rdest := bytecode(26 downto 24);
		ra := bytecode(23 downto 21);
		rb := bytecode(20 downto 18);
		
    -- Both operand will be Reg
    op_a <= '0';
		op_b <= '0';
		
		addrRA <= ra;
		addrRB <= rb;
		addrDest <= rdest;
		
    -- Enable w access
		en_reg <= '1';
		
    -- Send opcode to ALU
		opcode_out <= op;

  when "01" => 
    -- Get registers address
		rdest := bytecode(26 downto 24);
		ra := bytecode(23 downto 21);

    -- Get imm from bytecode
    imm := bytecode(20 downto 5);
   
    -- Operand A will be imm and Operand B will be Reg
    op_a <= '1';
    op_b <= '0';

    -- Write address
    addrDest <= rdest;
    addrRa <= ra;

    -- Enable w access
    en_reg <= '1';

    -- Send opcode to ALU
    opcode_out <= op;
    
    -- Send imm
    immA <= imm;
  when "10" =>
    -- Get rdest
		rdest := bytecode(26 downto 24);
    case op is
      when "000" =>
        imm := "1111111111111111";
        opcode_out <= "101";
        
        addrDest <= rdest;
        addrRa <= rdest;
        
        en_reg <= '1';
        
        -- Operand A will be imm and Operand B will be Reg
        op_a <= '1';
        op_b <= '0';
        
        -- Send imm
        immA <= imm;

      when others =>
        null;
    end case;

  when others =>
		null;
end case;
end if;

end process;
end architecture;



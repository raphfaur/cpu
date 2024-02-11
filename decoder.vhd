LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

	
ENTITY DECODER IS 
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

end DECODER;

architecture decoder1 of DECODER is 

signal counter : std_logic := '0';
begin

process (clk, rst)
variable opcode : std_logic_vector(5 downto 0);
variable format : std_logic_vector(1 downto 0);
variable op : std_logic_vector(2 downto 0);
variable rdest : std_logic_vector(2 downto 0);
variable ra : std_logic_vector(2 downto 0);
variable rb : std_logic_vector(2 downto 0);
variable imm : std_logic_vector(15 downto 0);

begin
if rst='1' then
    fetch_load <= '0';
    addrDest <= (others => '0');
    immA <= (others => '0');
    immB <= (others => '0');
    op_A <= '0';
    op_B <= '0';
    opcode_out <= (others => '0');
    addrRA <= (others => '0');
    addrRB <= (others => '0');
    en_reg <= '0';
    fetch_jmp <= "00000000";
else 
if rising_edge(clk) then
  
format := bytecode(31 downto 30);
op := bytecode(29 downto 27);
if format /= "10" or op /= "101" then
  fetch_load <= '0';
end if;
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
		rb := bytecode(23 downto 21);

    -- Get imm from bytecode
    imm := bytecode(20 downto 5);
   
    -- Operand A will be imm and Operand B will be Reg
    op_a <= '1';
    op_b <= '0';

    -- Write address
    addrDest <= rdest;
    addrRb <= rb;

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
      -- INC RDEST
      when "000" =>
        imm := "0000000000000001";
        opcode_out <= "000";
        
        addrDest <= rdest;
        addrRb <= rdest;

        -- Wait register file
        if counter ='1' then
          en_reg <= '1';
          counter <= '0';
        else
          counter <= '1';
          en_reg <= '0';
        end if;
        
        -- Operand A will be imm and Operand B will be Reg
        op_a <= '1';
        op_b <= '0';
        
        -- Send imm
        immA <= imm;

      -- DEC RDEST
      when "001" =>
        imm := "0000000000000001";
        opcode_out <= "001";
        
        addrDest <= rdest;
        addrRa <= rdest;

        -- Wait register file
        if counter ='1' then
          en_reg <= '1';
          counter <= '0';
        else
          counter <= '1';
          en_reg <= '0';
        end if;
        
        -- Operand B will be imm and Operand A will be Reg
        op_a <= '0';
        op_b <= '1';
        
        -- Send imm
        immB <= imm;
      
      -- NOOP
      when "010" =>
        en_reg <= '0';
        null;
      
      -- MOV IMM -> RDEST
      when "011" =>
        imm := bytecode(20 downto 5);
        -- Use ALU bypass
        opcode_out <= "111";

        addrDest <= rdest;

        -- Wait register file
        if counter ='1' then
          en_reg <= '1';
          counter <= '0';
        else
          counter <= '1';
          en_reg <= '0';
        end if;

        op_a <= '1';
        op_b <= '0';

        immA <= imm;
      
      -- MOV RA -> RDEST
      when "100" =>

        -- Use ALU bypass
        opcode_out <= "111";
        addrDest <= rdest;
        -- Wait register file
        if counter ='1' then
          en_reg <= '1';
          counter <= '0';
        else
          counter <= '1';
          en_reg <= '0';
        end if;
        
        op_a <= '0';

        addrRA <= bytecode(23 downto 21);
      
      -- JMP
      when "101" =>
        fetch_jmp <= bytecode(20 downto 13);
        
        if counter ='1' then
          fetch_load <= '1';
          counter <= '0';
        else
          counter <= '1';
          fetch_load <= '0';
        end if;

      when others =>
        null;
    end case;

  when others =>
		null;
end case;
end if;
end if;

end process;
end architecture;



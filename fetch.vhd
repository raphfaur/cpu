library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity Fetch is
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
end Fetch;


architecture Fetch_a of Fetch is

signal PC_counter: std_logic_vector(7 downto 0);
signal delay : std_logic := '0';
Begin


Process (clk, rst)
begin

	if rst='1' then
	  delay <= '0';
		PC_counter<= (others=>'0');
	
	else
	
		If rising_edge(clk) then
			if en='1' then
				If PC_Load='0' then
          if delay='1' then
            PC_counter<=std_logic_vector(unsigned(PC_counter)+1);
          end if;
				else
					PC_counter<=PC_jump;
				end if;
			end if;
      delay <= not delay;
		end if;
	end if;
	
end Process;
ram_en <= '1';
ram_rw <= '1';
PC_out <= PC_counter;

end Architecture Fetch_a;

	
			
	

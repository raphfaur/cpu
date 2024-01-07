library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

Entity RegFile is 
	port (
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

end RegFile;

Architecture RegFile_base of RegFile is 

type reg is array (7 downto 0) of std_logic_vector (15 downto 0);
signal registers : reg;

Begin

Process (clk, rst)
begin 
if rst = '1' then
	for i in 0 to 7 loop
		registers(i) <= (others => '0');
	end loop;
elsif rising_edge(clk) then
	if en='1' then 
		for i in 0 to 7 loop
			if to_integer(unsigned(addr)) = i then
				registers(i) <= w;
			end if;
		end loop;
	else 
		outA <= registers(to_integer(unsigned(addrA)));
		outB <= registers(to_integer(unsigned(addrB)));
	end if;
end if;

end Process;

end Architecture RegFile_base;
		
		




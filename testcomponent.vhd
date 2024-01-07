library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;

Entity Test is 
	port (
	clk : in std_logic;
	output : out std_logic
);

end Test;

Architecture Test_base of Test is 
begin

output <= '1';

end Architecture ;
		
		




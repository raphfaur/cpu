library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;
use std.textio.all;

entity ram is
	port(
			rw,en		:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_in	:	in std_logic_vector(31 downto 0);
			Data_out:	out std_logic_vector(31 downto 0)
			);
end ram;

architecture ram_a of ram is

type flashable_ram is array(0 to 255) of BIT_VECTOR(31 downto 0);
type flashable is array(0 to 255) of std_logic_vector(31 downto 0);

impure function InitRamFromFile(Filename : in String) return flashable_ram is

  File readFile : text is in Filename;
  Variable lineRead : line;
    Variable my_ram : flashable_ram;
  begin
    for i in flashable_ram'range loop
      readline(readFile,lineRead);
      read(lineRead, my_ram(i));      
    end loop;

    return my_ram;
end function;

function to_std(v : flashable_ram) return flashable is
variable output : flashable;
begin
  for k in 0 to 255 loop
    output(k) := to_stdlogicvector(v(k));
  end loop;
  return output;
end function;

signal flash : flashable_ram := InitRamFromFile("assembly/main.img") ;

type ram is array(0 to 255) of std_logic_vector(31 downto 0);

signal Data_Ram : flashable := to_std(flash);

--------------- BEGIN -----------------------------------------------------------------
begin
-- rw='1' alors lecture
	acces_ram:process(rst, clk)
		begin
		
		if rst='1' then
			--for k in 0 to 255 loop
				--Data_Ram(k) <= (others=>'0');
			--end loop;
		  null;
		else
			if rising_edge(clk) then
				if en='1' then
					if(rw='1') then 
						Data_out <= Data_Ram(to_integer(unsigned(Adress)));
					else
						Data_Ram(to_integer(unsigned(Adress))) <= Data_in;
					end if;
				end if;
			end if;
		end if;
		
	end process acces_ram;

end ram_a;

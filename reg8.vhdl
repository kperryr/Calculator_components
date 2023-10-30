library ieee;
use ieee.std_logic_1164.all;

entity reg8 is 

port( 		I       : in std_logic_vector(7 downto 0);  -- input data to write to regsiter
		clk, EN : in std_logic; -- clock and write enable
		O       : out std_logic_vector(7 downto 0) -- out register value
    );
end entity;

architecture behav of reg8 is
	signal output : std_logic_vector ( 7 downto 0) := "00000000";	-- register is intially zero
begin
	process(clk)
	begin	
		if (rising_edge(clk)) then  -- if rising edge
			if (EN = '1')  then -- if write enable = '1'
				output <= I;  -- write to register
			else
				output <= output; -- if not, no register writing will occur
			end if;
		end if;
	end process;
	O <= output; -- register output data
end behav;


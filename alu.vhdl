library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 

port( 		rA,rB   : in std_logic_vector(7 downto 0); -- two 8-bit input values
		op      : in std_logic_vector(1 downto 0); -- operation code
		equal   : out std_logic; -- output that = 1 if rA == rB and =0 otherwise
		O       : out std_logic_vector(7 downto 0) -- output of operation of ALU
    );
end entity;

architecture behav of ALU is

	
begin
	process(rA,rB,op) --combo logic
	begin	
		if (op = "00") then  --ADD
			O <= std_logic_vector(unsigned(rA) + unsigned(rB));  -- add rA and rB
			equal <= 'U';  
		elsif (op = "01") then --SUB

			O <= std_logic_vector(unsigned(rA) - unsigned(rB)); --SUB : rA - rB
			equal <= 'U';
		elsif (op = "10") then -- does nothing
			--do Nothing
			equal <= 'U'; 
		else   -- compare two register
			if (rA = rB) then
				equal <= '1';  --if equal
				O <= "UUUUUUUU";
			else
				equal <= '0';  --if not equal
				O <= "UUUUUUUU";

			end if;
		end if;
	end process;
end behav;


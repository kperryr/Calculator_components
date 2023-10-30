library ieee;
use ieee.std_logic_1164.all;

entity regfile is 

port( 		rs1,rs2,ws  : in std_logic_vector(1 downto 0);  -- read from registers and write register (ws)
		wd          : in std_logic_vector( 7 downto 0); -- write data
		clk, WE     : in std_logic; -- clock and write enable
		rd1,rd2     : out std_logic_vector(7 downto 0) -- read registers data values
    );
end entity;

architecture behav of regfile is
-- component 8-bit registers
component reg8
port( 	I       : in std_logic_vector(7 downto 0);
      	clk, EN : in std_logic;
      	O       : out std_logic_vector(7 downto 0)
      );
end component;

signal mem0, mem1, mem2, mem3 : std_logic_vector( 7 downto 0) := "00000000"; --stores value of four 8-bit registers and intialized to zero
signal en1, en2, en3, en4 : std_logic; -- write enables for all four registers


for reg1 : reg8 use entity WORK.reg8(behav);
for reg2 : reg8 use entity WORK.reg8(behav);
for reg3 : reg8 use entity WORK.reg8(behav);
for reg4 : reg8 use entity WORK.reg8(behav);
	
begin

	write: process(WE, ws)
	begin	
				if (ws = "00") then				-- write to reg 1
					en1 <= WE;
					en2 <= '0';
					en3 <= '0';
					en4 <= '0';
				elsif (ws = "01") then 				-- write to reg 2 
					en1 <= '0';
					en2 <= WE;
					en3 <= '0';
					en4 <= '0';
				elsif (ws = "10") then 				-- write to reg 3
					en1 <= '0';
					en2 <= '0';
					en3 <= WE;
					en4 <= '0';
				else 						--write to reg 4
					en1 <= '0';
					en2 <= '0';
					en3 <= '0';
					en4 <= WE;
				end if;
	end process;
				--component instantiation
				reg1: reg8 port map(I => wd, clk => clk, EN => en1, O => mem0 );
				reg2: reg8 port map(I => wd, clk => clk, EN => en2, O => mem1 );
				reg3: reg8 port map(I => wd, clk => clk, EN => en3, O => mem2 );
				reg4: reg8 port map(I => wd, clk => clk, EN => en4, O => mem3 );
						 
	read: process(WE,rs1,rs2,mem0,mem1,mem2,mem3)
	begin

	       if ( rs1 = "00") then -- read reg 0
			rd1 <= mem0;

	       elsif ( rs1 = "01") then -- read reg 1
		       rd1 <= mem1;
		
	       elsif ( rs1 = "10") then --read reg 2
		       rd1 <= mem2;
	      	
	       elsif ( rs1 = "11") then	--read reg 3
		       rd1 <= mem3;
		
	       else
			rd1 <= "ZZZZZZZZ";
	       end if;
	      
			
	       if ( rs2 = "00") then  --read reg 0
			rd2 <= mem0;

	       elsif ( rs2 = "01") then --read reg 1
			rd2 <= mem1;

	       elsif ( rs2 = "10") then -- read reg 2
			rd2 <= mem2;

	       elsif ( rs2 = "11") then  --read reg 3
	      		rd2 <= mem3;

	       else
		       rd2 <= "ZZZZZZZZ";
		end if;


	end process;

end behav;


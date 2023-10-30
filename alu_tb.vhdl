library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity alu_tb is
end alu_tb;

architecture behav of alu_tb is
--  Declaration of the component that will be instantiated.
component alu
port (		rA,rB             : in std_logic_vector (7 downto 0);
		op                : in std_logic_vector (1 downto 0);
		equal             : out std_logic;
		O                 : out std_logic_vector(7 downto 0) 
);
end component;
--  Specifies which entity is bound with the component.
for ALU_0: ALU use entity work.ALU(behav);
signal RA,RB,o : std_logic_vector(7 downto 0);
signal equal : std_logic;
signal op : std_logic_vector(1 downto 0);

begin
--  Component instantiation.
ALU_0: ALU port map (		rA => RA, 
				rB => RB, 
				equal => equal, 
				op => op, 
				O =>o);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the alu.
rA,rB: std_logic_vector (7 downto 0);
op: std_logic_vector(1 downto 0);
--  The expected outputs of the alu.
equal :std_logic;
o: std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := 
(
--Test add
("00000000", "00000001",  "00",   'U', "00000001"), -- ADD 0+1 = 1
("11111110", "00000001",  "00",   'U', "11111111"), -- ADD 254 + 1 = 255

--Test sub
("00000001", "00000000",  "01",   'U', "00000001"), -- SUB 1 - 0 = 1
("11111111", "00000001",  "01",   'U', "11111110"), -- SUB 255-1 = 254

--Test Nothing
("00000001", "00000000",  "10",   'U', "11111110"), -- DOES NOTHING TO OUTPUTS
("11111111", "00000001",  "10",   'U', "11111110"), -- DOES NOTHING TO OUTPUTS


--Test set on equal
("00000001", "00000001",  "11",   '1', "UUUUUUUU"), -- registers are equal: equal = 1
("00000001", "00000011",  "11",   '0', "UUUUUUUU") -- registers are not equal : equal = 0

); 

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
rA<= patterns(n).rA;
rB<= patterns(n).rB;
op <= patterns(n).op;

--  Wait for the results.

wait for 1 ns;
--  Check the outputs.
assert equal = patterns(n).equal;
assert o = patterns(n).o
--assert equal = patterns(n).equal
report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;

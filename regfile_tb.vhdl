library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity regfile_tb is
end regfile_tb;

architecture behav of regfile_tb is
--  Declaration of the component that will be instantiated.
component regfile
port (		rs1,rs2,ws        : in std_logic_vector (1 downto 0);
		wd                : in std_logic_vector (7 downto 0);
		clk,WE            : in std_logic;
		rd1,rd2           : out std_logic_vector(7 downto 0) 
);
end component;
--  Specifies which entity is bound with the component.
for regfile_0: regfile use entity work.regfile(behav);
signal WD,RD1,RD2 	: std_logic_vector(7 downto 0);
signal we		: std_logic;
signal CLK		: std_logic;
signal RS1,RS2,WS	: std_logic_vector(1 downto 0);
begin
--  Component instantiation.
regfile_0: regfile port map (	rs1 => RS1, 
				rs2 => RS2, 
				ws  => WS, 
				wd  => WD, 
				clk => CLK, 
				WE  => we, 
				rd1 => RD1,
				rd2 => RD2);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the regfile.
wd: std_logic_vector (7 downto 0);
rs1,rs2,ws: std_logic_vector(1 downto 0);
clk, WE  :std_logic;
--  The expected outputs of the regfile.
rd1,rd2 : std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array := 
(
-- test intialization
--ALL READS from register are expected to be "00000000"
-- WE = '0' no wiriting will occur
("11111111", "00","01","00",'0', '0', "00000000","00000000"), -- no rising edge : read reg 0 and 1
("11111111", "00","01","00",'1', '0', "00000000","00000000"), -- rising edge : read register 0 and 1
("11111111", "01","00","01",'0', '0', "00000000","00000000"), -- no rising edge: read register 1 and 0
("11111111", "01","00","01",'1', '0', "00000000","00000000"), -- rising edge: read register 1 and 0 
("11111111", "10","11","10",'0', '0', "00000000","00000000"), -- no rising edge: read register 2 and 3
("11111111", "10","11","10",'1', '0', "00000000","00000000"), -- rising edge : read register 2 and 3
("11111111", "11","10","11",'0', '0', "00000000","00000000"), -- no rising edge : read register 3 and 2
("11111111", "11","10","11",'1', '0', "00000000","00000000"), -- rising edge : read register 3 and 2

--test writing with data set 1

("11111111", "00","01","00",'0','1', "00000000","00000000"), -- no rising edge and no writng will occur : read from reg 0 and 1
("11111111", "00","01","00",'1','1', "11111111","00000000"), -- rising edge write to reg 0 : read from reg 0 and 1
("11111110", "01","00","01",'0','1', "00000000","11111111"), -- no rising edge and no wiritng will occur: read from reg 1 and 0
("11111110", "01","00","01",'1','1', "11111110","11111111"), -- rising edge write to reg 1: read from reg 1 and 0
("11111100", "10","11","10",'0','1', "00000000","00000000"), -- no rising edge and no writing will occur : read from reg 2 and 3
("11111100", "10","11","10",'1','1', "11111100","00000000"), -- rising edge write to reg 2 : read from reg 2 and 3
("11111000", "11","10","11",'0','1', "00000000","11111100"), -- no rising edge and no writing will occur: read from 3 and 2
("11111000", "11","10","11",'1','1', "11111000","11111100"), -- rising edge write to reg 3 : read from reg 3 and reg 2

-- test writing with data set 2
("00001111", "00","01","00",'0','1',"11111111","11111110"), -- no rising edge and no writing will occur : read from reg 0 and 1
("00001111", "00","01","00",'1','1',"00001111","11111110"), -- rising edge write to reg 0 : read from reg 0 and reg 1
("00011111", "01","00","01",'0','1',"11111110","00001111"), -- no rising edge and no writing will occur: read from reg 1 and 0
("00011111", "01","00","01",'1','1',"00011111","00001111"), -- rising edge write to reg 1 : read from reg 1 and 0
("00111111", "10","11","10",'0','1',"11111100","11111000"), -- no rising edge and no writing will occur: read from reg 2 and 3
("00111111", "10","11","10",'1','1',"00111111","11111000"), -- rising edge write to reg 2 : read from reg 2 and 3
("01111111", "11","10","11",'0','1',"11111000","00111111"), -- no rising edge and no writing will occur : read from reg 3 and 2
("01111111", "11","10","11",'1','1',"01111111","00111111")  -- rising edge write to reg 3: read from reg 3 and 2

); 

begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
ws<= patterns(n).ws;
rs1<= patterns(n).rs1;
rs2<= patterns(n).rs2;
wd<= patterns(n).wd;
clk<= patterns(n).clk;
WE<= patterns(n).WE;

--  Wait for the results.

wait for 1 ns;
--  Check the outputs.
assert rd1 = patterns(n).rd1;
assert rd2 = patterns(n).rd2
--assert equal = patterns(n).equal
report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;

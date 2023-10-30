all: reg8 regfile alu

reg8:
	/usr/local/bin/ghdl -a  --ieee=standard reg8.vhdl
	/usr/local/bin/ghdl -a  --ieee=standard reg_tb.vhdl
	/usr/local/bin/ghdl -e  --ieee=standard reg_tb
	/usr/local/bin/ghdl -r  --ieee=standard reg_tb --stop-time=16ns

regfile:
	/usr/local/bin/ghdl -a  --ieee=standard regfile.vhdl
	/usr/local/bin/ghdl -a  --ieee=standard regfile_tb.vhdl
	/usr/local/bin/ghdl -e  --ieee=standard regfile_tb
	/usr/local/bin/ghdl -r  --ieee=standard regfile_tb --stop-time=24ns

alu:
	/usr/local/bin/ghdl -a  --ieee=standard alu.vhdl
	/usr/local/bin/ghdl -a  --ieee=standard alu_tb.vhdl
	/usr/local/bin/ghdl -e  --ieee=standard alu_tb
	/usr/local/bin/ghdl -r  --ieee=standard alu_tb 

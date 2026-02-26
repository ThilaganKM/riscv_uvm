# Simulator
SIM = vsim
VLOG = vlog

# UVM Path
UVM_HOME = /home/cad/eda/Questa_2019/questasim/verilog_src/uvm-1.1d/src

# Files
RTL = \
 rtl/program_counter.sv \
 rtl/register_file.sv

TB = \
 tb/interfaces/pc_if.sv \
 tb/interfaces/rf_if.sv \
 tb/txn/riscv_txn_pkg.sv \
 tb/pc_tb_pkg.sv \
 tb/tb_top.sv

# Compile
compile:
	vlib work
	$(VLOG) -sv +incdir+$(UVM_HOME) $(RTL) $(TB)

# Run PC Test
pc:
	$(SIM) -c tb_top +UVM_TESTNAME=pc_test -do "run -all"

# Run RF Test
rf:
	$(SIM) -c tb_top +UVM_TESTNAME=rf_test -do "run -all"

# Clean
clean:
	rm -rf work transcript vsim.wlf
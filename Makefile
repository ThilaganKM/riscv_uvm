#--------------------------------------------------
# Simulator Setup
#--------------------------------------------------

SIM  = vsim
VLOG = vlog

#--------------------------------------------------
# UVM Path
#--------------------------------------------------

UVM_HOME = /home/cad/eda/Questa_2019/questasim/verilog_src/uvm-1.1d/src

#--------------------------------------------------
# RTL Files
#--------------------------------------------------

RTL = \
 rtl/PC.sv \
 rtl/register_file.sv \
 rtl/ALU.sv \
 rtl/Alu_decoder.sv \
 rtl/forwarding_unit.sv \
 rtl/HazardUnit.sv \
 rtl/main_decoder.sv

#--------------------------------------------------
# Interface Files
#--------------------------------------------------

INTERFACES = \
 tb/interfaces/pc_if.sv \
 tb/interfaces/rf_if.sv \
 tb/interfaces/alu_if.sv \
 tb/interfaces/alu_dec_if.sv \
 tb/interfaces/fwd_if.sv \
 tb/interfaces/haz_if.sv \
 tb/interfaces/main_dec_if.sv

#--------------------------------------------------
# Transaction Package
#--------------------------------------------------

TXN = \
 tb/txn/riscv_txn_pkg.sv

#--------------------------------------------------
# Testbench Package
#--------------------------------------------------

TBPKG = \
 tb/pc_tb_pkg.sv

#--------------------------------------------------
# Top Module
#--------------------------------------------------

TOP = \
 tb/tb_top.sv

#--------------------------------------------------
# Compile (ORDER IS CRITICAL)
#--------------------------------------------------

compile:
	vlib work

	$(VLOG) -sv +incdir+$(UVM_HOME) $(INTERFACES)
	$(VLOG) -sv +incdir+$(UVM_HOME) $(TXN)
	$(VLOG) -sv +incdir+$(UVM_HOME) $(TBPKG)
	$(VLOG) -sv +incdir+$(UVM_HOME) $(RTL)
	$(VLOG) -sv +incdir+$(UVM_HOME) $(TOP)

#--------------------------------------------------
# Run Tests
#--------------------------------------------------

pc:
	$(SIM) -c tb_top +UVM_TESTNAME=pc_test -do "run -all"

rf:
	$(SIM) -c tb_top +UVM_TESTNAME=rf_test -do "run -all"

alu:
	$(SIM) -c tb_top +UVM_TESTNAME=alu_test -do "run -all"

alu_dec:
	$(SIM) -c tb_top +UVM_TESTNAME=alu_dec_test -do "run -all"

fwd:
	$(SIM) -c tb_top +UVM_TESTNAME=fwd_test -do "run -all"

haz:
	$(SIM) -c tb_top +UVM_TESTNAME=haz_test -do "run -all"
main_dec:
	$(SIM) -c tb_top +UVM_TESTNAME=main_dec_test -do "run -all"

#--------------------------------------------------
# Clean Build
#--------------------------------------------------

clean:
	rm -rf work transcript vsim.wlf
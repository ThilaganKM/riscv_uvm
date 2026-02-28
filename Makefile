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
 rtl/main_decoder.sv \
 rtl/control_unit.sv \
 rtl/data_mem.sv \
 rtl/instr_mem.sv \
 rtl/IF_ID.sv \
 rtl/ID_IE.sv \
 rtl/IE_IM.sv \
 rtl/IM_IW.sv \
 rtl/mux2.sv \
 rtl/mux3to1.sv \
 rtl/Adder.sv \
 rtl/ExtendUnit.sv \
 rtl/rvhazard.sv \
 rtl/rvhazard_dbg.sv

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
 tb/interfaces/main_dec_if.sv \
 tb/interfaces/control_unit_if.sv \
 tb/interfaces/data_mem_if.sv

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

PIPE_TOP = \
 tb/tb_pipeline_top.sv
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
	$(VLOG) -sv +incdir+$(UVM_HOME) $(PIPE_TOP)

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

ctrl:
	$(SIM) -c tb_top +UVM_TESTNAME=control_unit_test -do "run -all"

dmem:
	$(SIM) -c tb_top +UVM_TESTNAME=data_mem_test -do "run -all"

pipeline:
	$(SIM) -c tb_pipeline_top -do "run -all"

#--------------------------------------------------
# Clean Build
#--------------------------------------------------

clean:
	rm -rf work transcript vsim.wlf
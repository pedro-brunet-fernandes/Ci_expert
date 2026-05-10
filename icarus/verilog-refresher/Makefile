
BLOCK    ?= 8x1mux

# RTL
RTL_FILES = rtl/$(BLOCK).v

# TB
TB_FILES  = tb_systemverilog/tb_$(BLOCK).sv

# VCS
FSDB_FILE = $(BLOCK)
VCS_KDB   = -kdb 
VCS_DEBUG = -debug_access+all
VCS_FLAGS = -full64 -l ./vcs_logger.log $(VCS_KDB) $(VCS_DEBUG) -timescale=1ns/1ps

vcs:
	vcs $(VCS_FLAGS) $(RTL_FILES) $(TB_FILES) 

run: 
	./simv +FSDB=$(BLOCK).fsdb

gui:
	./simv -gui

verdi_wf:
	verdi -play cmd/$(BLOCK).cmd

verdi_wf_easy:
	verdi -nologo -ssf $(BLOCK).fsdb

verdi_sc:
	verdi -play schematic-top.cmd

vcs_clean:
	rm -rf csrc *.daidir simv *.log *.key *.conf *.rc *.fsdb verdiLog/



SIM_DIR = sim
OUT = $(SIM_DIR)/$(BLOCK).vvp
VCD = $(SIM_DIR)/$(BLOCK).vcd


icarus:	
	mkdir -p $(SIM_DIR)
	iverilog -g2012 -o $(OUT) $(RTL_FILES) $(TB_FILES)

run_icarus: icarus
	vvp $(OUT) +VCD=$(VCD)

wave_icarus: run_icarus
	gtkwave $(VCD)

clean_icarus :
	rm -rf $(SIM_DIR)/*.vvp $(SIM_DIR)/*.v
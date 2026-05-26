SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Add your Verilog source file path
VERILOG_SOURCES += $(PWD)/../src/tt_um_example.v

# Top-level module name matching your Verilog file structure
TOPLEVEL = tt_um_example

# Python module file name containing the test routines
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim

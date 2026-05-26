# Makefile for Tiny Tapeout Verification Flow
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Add your Verilog source file path
VERILOG_SOURCES += $(PWD)/../src/tt_um_example.v

# Top-level module name matching your Verilog file structure
TOPLEVEL = tt_um_example

# Python module file name containing the @cocotb.test routines
MODULE = test

# Include cocotb's automated makefile compilation architecture
include $(shell cocotb-config --makefiles)/Makefile.sim

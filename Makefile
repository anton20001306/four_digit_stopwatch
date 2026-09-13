# ============================================================
#  Generic QuestaSim Makefile
#
#  Use the defaults with:
#      make gui
#
#  Override the project from the command line, for example:
#      make gui SRC_DIR=bit_seq_detector \
#          RTL_SRCS="mealy.sv" \
#          TB_SRC=bit_pattern_tb.sv \
#          TB_TOP=bit_pattern_tb
# ============================================================

# Default project. Override these variables on the make command line.
SRC_DIR  ?= adders
RTL_SRCS ?= n_adder.sv
TB_SRC   ?= n_adder_tb.sv
TB_TOP   ?= n_adder_tb

# Generic waveform script in the same directory as this Makefile.
WAVE_DO  ?= wave.do

# QuestaSim binaries. Example:
#   make gui QUESTA_BIN=/opt/questasim/2024.1/bin/
QUESTA_BIN ?=
VLIB = $(QUESTA_BIN)vlib
VLOG = $(QUESTA_BIN)vlog
VSIM = $(QUESTA_BIN)vsim
WORK = work

# Prefix source files with their project directory.
SRCS = $(addprefix $(SRC_DIR)/, $(RTL_SRCS) $(TB_SRC))

.PHONY: all gui run compile clean

all: gui

compile:
	$(VLIB) $(WORK)
	$(VLOG) $(SRCS)

gui: compile
	$(VSIM) -gui -voptargs="+acc" $(WORK).$(TB_TOP) -do "do $(WAVE_DO); run -all; wave zoom full"

run: compile
	$(VSIM) -c $(WORK).$(TB_TOP) -do "run -all; quit -f"

clean:
	rm -rf $(WORK) transcript vsim.wlf vsim_stacktrace.vstf modelsim.ini *.vcd *.wlf
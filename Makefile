TOP := bit_pattern_tb
WORK := work
VLOG := vlog
VSIM := vsim

.PHONY: all compile sim gui clean

all: sim

$(WORK):
	vlib $(WORK)

compile: $(WORK)
	$(VLOG) -work $(WORK) bit_seq_detector/mealy.sv bit_seq_detector/bit_pattern_tb.sv

sim: compile
	$(VSIM) -c -lib $(WORK) $(TOP) -do "do sim.tcl"

gui: compile
	$(VSIM) -gui -voptargs=+acc -lib $(WORK) $(TOP) -do "do sim_gui.tcl"

clean:
	rm -rf $(WORK) transcript vsim.wlf bit_pattern_tb.vcd
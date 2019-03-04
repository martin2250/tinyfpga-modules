PROJ = top
DEVICE = lp8k
PIN_DEF = pins.pcf

all: $(PROJ).rpt $(PROJ).bin

############ BUILD ############

%.blif: %.v
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d 8k -P cm81 -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

############ SIMULATE ############

%_tb.vvp: %.v %_tb.v
	iverilog -tvvp -s tb -o $@ $^

%_tb.vcd: %_tb.vvp
	vvp -N $< -vcd

%.sim: %_tb.vcd
	gtkwave $< -a $*_tb.gtkw

############ GRAPH ############

%.dot: %.v
	yosys -p 'prep; show -stretch -format svg -viewer inkscape' $<

############ TOOLS ############

prog: $(PROJ).bin
	tinyprog -p $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.SECONDARY:
.PHONY: all prog clean

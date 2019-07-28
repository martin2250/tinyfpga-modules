PROJ = $(shell basename "$(CURDIR)")

.PHONY: all
all: $(PROJ).bin

############ BUILD ############

%.json: %.v
	yosys -p 'synth_ice40 -top $(PROJ) -json $@' $<

%.asc: %.json $(PIN_DEF)
	nextpnr-ice40 --lp8k --package cm81 --json $< --pcf pins.pcf --asc $@ $(PNR_ARGS) --gui

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

############ SIMULATE ############

%_tb.vvp: %.v %_tb.v
	iverilog -tvvp -s tb -o $@ $^

%.vcd: %.vvp
	vvp -N $< -vcd

.PHONY: sim
sim: $(PROJ)_tb.vcd

.PHONY: simshow
simshow: $(PROJ)_tb.vcd
	nohup gtkwave $< -a $(PROJ)_tb.gtkw >/dev/null 2>&1 &

############ GRAPH ############

.PHONY: show
show: $(PROJ).v
	yosys -p 'prep; show  -stretch -format dot -viewer xdot' $<

############ TOOLS ############

.PHONY: prog
flash: $(PROJ).bin
	tinyprog -p $<

.PHONY: clean
clean:
	git clean -Xf



checks:
	python3 ../../checks/genchecks.py
	$(MAKE) -C checks

check: checks
	bash cexdata.sh
	cat cexdata/warnings.txt
	cat cexdata/status.txt

clean:
	rm -rf firmware.elf firmware.hex testbench testbench.vcd gtkwave.log
	rm -rf disasm.o disasm.s checks/ cexdata/

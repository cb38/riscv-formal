#!/bin/bash
#


set -ex

rm -rf cexdata
mkdir cexdata

# Collect FAIL traces (nullglob avoids errors when no FAILs exist)
shopt -s nullglob
for x in checks/*/FAIL testbug[0-9][0-9][0-9]/*/FAIL; do
	test -f "$x" || continue
	x=${x%/FAIL}
	y=${x/\//_}
	cp "$x/logfile.txt" "cexdata/$y.log"
	# Use find to safely locate trace.vcd regardless of engine name
	trace=$(find "$x" -name "trace.vcd" -maxdepth 2 | head -1)
	if [ -n "$trace" ]; then
		cp "$trace" "cexdata/$y.vcd"
		python3 disasm.py "cexdata/$y.vcd" > "cexdata/$y.asm"
	fi
done
shopt -u nullglob

# Collect warnings from all logfiles that exist
logfiles=()
shopt -s nullglob
for d in checks/*/logfile.txt testbug[0-9][0-9][0-9]/*/logfile.txt; do
	logfiles+=("$d")
done
shopt -u nullglob
if [ ${#logfiles[@]} -gt 0 ]; then
	sed -E '/WARNING|[Ww]arning/!d; /\[VERI-1927\] .*\/wrapper\.sv:/d; s/^([^:]|:[^ ])*: //' "${logfiles[@]}" | sort -u > cexdata/warnings.txt
else
	touch cexdata/warnings.txt
fi

# Build status table for each .sby
get_time() {
	grep 'Elapsed process time' "$1" 2>/dev/null | sed -E 's/.*\]: ([^ ]+).*/\1/' | head -1
}

shopt -s nullglob
for x in checks/*.sby testbug[0-9][0-9][0-9]/*.sby; do
	test -f "$x" || continue
	x=${x%.sby}
	if [ -f "$x/PASS" ]; then
		t=$(get_time "$x/logfile.txt" 2>/dev/null || true)
		printf "%-30s %s %10s\n" "$x" "  pass  " "${t:-?}"
	elif [ -f "$x/FAIL" ]; then
		t=$(get_time "$x/logfile.txt" 2>/dev/null || true)
		printf "%-30s %s %10s\n" "$x" "**FAIL**" "${t:-?}"
	else
		printf "%-30s %s\n" "$x" unknown
	fi
done | awk '{ gsub(":", "", $3); print $3, $0; }' | sort -n | cut -f2- -d' ' > cexdata/status.txt
shopt -u nullglob


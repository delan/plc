#!/bin/sh

expected='parser: found basic_program'

for i in *.pl2014; do
	result=$(../../PL2014_check < "$i" 2>&1 | tail -n 1)
	if [ "$result" == "$expected" ]; then
		echo "[FAIL] $i"
	else
		echo "[PASS] $i"
	fi
done

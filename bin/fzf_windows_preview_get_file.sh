#!/usr/bin/env bash

echo "${1}" | awk -e '{
	split($0, words, " ")
	file = ""
	sep = ""
	for (i=3; i in words; i++) {
		if (words[i] != ">") {
			file = file sep words[i]
			sep = " "
		}
	}
	print file
}'

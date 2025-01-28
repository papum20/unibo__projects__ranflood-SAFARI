#!/usr/bin/env python3

import json
import os
import re
import sys


KEYS_REGEX = {
	"tot_checksum" : "Tot: saved in checksum.*",
	"tot_checksum_still_present" : "Tot: saved in checksum and still present, with correct signature.*",
	"recovered" : "Recovered: present in checksum and file not existing, but now recovered.*",
	"recovered_path_conflict" : "Recovered, path conflict: recovered but changed name because a different file with the same name was found.*",
	"recovered_wrong_checksum" : "Recovered, wrong checksum: recovered but changed name because snapshot has a different checksum.*",
	"recovered_already_existing" : "Recovered: already existing, with correct signature.*",
	"recovered_new" : "Recovered: new files, not present in the checksum.*",
	"already_existing" : "Already existing, with correct signature.*",
	"error_write_file" : "Couldn't write these files, retry.*",
	"error_delete_shard" : "Couldn't delete these shards, but they can be removed safely as they were already recovered.*",
	"error_checksum" : "Error: checksum.*",
	"error_insufficient_shards" : "Error: insufficient shards.*",
	"error_other" : "Error: other.*",
	"stats" : "Stats.*",
}


def process_file(file_path):
	"""
	Find files and count them for each entry,
	also checking that each file only appears once
	(in case, only keep one entry, according to our choices).
	"""
	with open(file_path, 'r') as file:
		data = json.load(file)
	
	entry_counts = {}
	entry_files = {}

	for key, value in data.items():
		if isinstance(value, list):
			entry_counts[key] = len(value)
			entry_files[key] = value

	# check consistency (each file only in one entry)
	analyzed_files = {}

	for key, files in entry_files.items():
		for file in files:
			if (not re.match(KEYS_REGEX["tot_checksum"], key)) and file in analyzed_files.values():
				print(f"[WARNING]: {file} found twice, removing... (old key: {list(filter(lambda k: analyzed_files[k] == file, analyzed_files))[0]}; new key: '{key}')")
				entry_files[key].remove(file)
				entry_counts[key] -= 1
			elif file not in analyzed_files.values():
				analyzed_files[key] = file

	return entry_counts, entry_files

def process_directory(directory, pattern):
	"""
	Return averages.
	"""
	entry_counts = {}
	counts_avg = {}
	count = 0

	for root, _, files in os.walk(directory):
		for file in files:
			if re.match(pattern, file):
				file_path = os.path.join(root, file)
				print(f"Processing {file_path} ...")
				
				counts, files = process_file(file_path)

				for key, value in counts.items():
					if key in entry_counts:
						entry_counts[key].append(value)
						counts_avg[key] += value
					else:
						entry_counts[key] = [value]
						counts_avg[key] = value
				count += 1

	# average
	for key, value in counts_avg.items():
		counts_avg[key] = value / count

	return count, entry_counts, counts_avg


if __name__ == "__main__":

	pattern = "report2.*"

	if len(sys.argv) != 2:
		print("Usage: average.py <directory>")
		sys.exit(1)

	directory = sys.argv[1]

	count, entry_counts, counts_avg = process_directory(directory, pattern)

	print(f"Entry counts (files: {count}):")
	for key, count in counts_avg.items():
		print(f"{key}: {count}")
	for key, counts in entry_counts.items():
		print(f"{key}: {str(counts)}")

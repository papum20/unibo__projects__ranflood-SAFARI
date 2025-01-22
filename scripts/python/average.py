#!/usr/bin/env python3

import json
import os
import re
import sys


KEYS_REGEX = {
	"tot_checksum" : "Tot: saved in checksum (filtered).*",
	"tot_checksum_still_present" : "Tot: saved in checksum and still present, with correct signature.*",
	"recovered" : "Recovered: present in checksum and file not existing, but now recovered (including path conflict).*",
	"recovered_path_conflict" : "Recovered, path conflict: recovered but changed name because a different file with the same name was found.*",
	"recovered_wrong_checksum" : "Recovered, wrong checksum: recovered but changed name because snapshot has a different checksum.*",
	"recovered_already_existing" : "Recovered: already existing, with correct signature.*",
	"recovered_new" : "Recovered: new files, not present in the checksum (including wrong checksum).*",
	"already_existing" : "Already existing, with correct signature (including recovered but already existing).*",
	"error_write_file" : "Couldn't write these files, retry\..*",
	"error_delete_shard" : "Couldn't delete these shards, but they can be removed safely as they were already recovered.*",
	"error_checksum" : "Error: checksum (scan).*",
	"error_insufficient_shards" : "Error: insufficient shards (scan).*",
	"error_other" : "Error: other (scan).*",
	"stats" : "Stats (scan).*",
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
	analyzed_files = []

	for key, files in entry_files.items():
		for file in files:
			if file in analyzed_files:
				print(f"[WARNING]: {file} found twice, removing... (new key: '{key}')")
				entry_files[key].remove(file)
				entry_counts[key] -= 1
			else:
				analyzed_files.append(file)

	return entry_counts, entry_files

def process_directory(directory, pattern):
	entry_counts = {}
	entry_files = {}

	for root, _, files in os.walk(directory):
		for file in files:
			if re.match(pattern, file):
				file_path = os.path.join(root, file)
				print(f"Processing {file_path}...")
				
				counts, files = process_file(file_path)
				entry_counts.update(counts)
				entry_files.update(files)

	return entry_counts, entry_files


if __name__ == "__main__":

	pattern = "report2.*"
	PRINT_FILES = False

	if len(sys.argv) != 2:
		print("Usage: average.py <directory>")
		sys.exit(1)

	directory = sys.argv[1]

	entry_counts, entry_files = process_directory(directory, pattern)

	print("Entry Counts:")
	for key, count in entry_counts.items():
		print(f"{key}: {count}")

	if PRINT_FILES:
		print("\nEntry Files:")
		for key, files in entry_files.items():
			print(f"{key}:")
			for file in files:
				print(f"  {file}")
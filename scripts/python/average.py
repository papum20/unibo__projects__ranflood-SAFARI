#!/usr/bin/env python3

import json
import os
import re
import sys


KEYS_REGEX = {
	"tot_checksum" : "Tot: saved in checksum \\(filtered\\).*",
	"tot_checksum_still_present" : "Tot: saved in checksum and still present, with correct signature.*",
	"recovered" : "Recovered: present in checksum and file not existing, but now recovered \\(including path conflict\\).*",
	"recovered_path_conflict" : "Recovered, path conflict: recovered but changed name because a different file with the same name was found.*",
	"recovered_wrong_checksum" : "Recovered, wrong checksum: recovered but changed name because snapshot has a different checksum.*",
	"recovered_already_existing" : "Recovered: already existing, with correct signature.*",
	"recovered_new" : "Recovered: new files, not present in the checksum \\(including wrong checksum\\).*",
	"already_existing" : "Already existing, with correct signature \\(including recovered but already existing\\).*",
	"error_write_file" : "Couldn't write these files, retry.*",
	"error_delete_shard" : "Couldn't delete these shards, but they can be removed safely as they were already recovered.*",
	"error_checksum" : "Error: checksum \\(scan\\).*",
	"error_insufficient_shards" : "Error: insufficient shards \\(scan\\).*",
	"error_other" : "Error: other \\(scan\\).*",
	"stats" : "Stats \\(scan\\).*",
}

FOLDERS = [
	'DOCUMENT',
	'DOWNLOAD',
	'Desktop',
	'Documents',
	'Downloads',
	'Music',
	'My Documents',
	'OneDrive',
	'Pictures',
	'PrintHood',
	'SAVED_GA',
	'SendTo',
	'Videos',
]


def processFile(file_path):
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
		key_regex = ""
		for k, v in KEYS_REGEX.items():
			if re.match(v, key):
				key_regex = k
				break
		if isinstance(value, list):
			entry_counts[key_regex] = len(value)
			entry_files[key_regex] = value

	# check consistency (each file only in one entry)
	# checksum -> key (for last found)
	analyzed_checksums = {}

	new_entry_counts = {}
	new_entry_files = {}
	for key, value in entry_counts.items():
		new_entry_counts[key] = 0
		new_entry_files[key] = []

	for key, files in entry_files.items():
		for file in files:
			path		= file["path"].lstrip('/mnt/win10/Users/IEUser/')
			checksum	= file["checksum"]
			print(f"[INFO]: {path}; {checksum}")
			#if file not in entry_files[key]:
			#	continue
			#if checksum in ('null', None):
			#	print(f"[WARNING]: {file} has no checksum, removing... (key: '{key}')")
			#	entry_files[key].remove(file)
			#	entry_counts[key] -= 1
			if not any(path.startswith(folder) for folder in FOLDERS):
				print(f"[WARNING]: {file} not in selected folders, removing... (key: '{key}')")
			#elif (not re.match(KEYS_REGEX["tot_checksum"], key)) and checksum in analyzed_checksums.keys():
			elif checksum in analyzed_checksums.keys() and analyzed_checksums[checksum] == key:
				print(f"[WARNING]: {file} found twice, removing... (old key: {analyzed_checksums[checksum]}; new key: '{key}')")
			# if already in tot and found now in recovered, will add again, replacing key
			else:
				if checksum in analyzed_checksums.keys():
					print(f"[INFO]: {checksum}; {analyzed_checksums[checksum]} -> {key}")
				else:
					print(f"[INFO]: {checksum}; {key}")
				analyzed_checksums[checksum] = key
				new_entry_counts[key] += 1
				new_entry_files[key].append(file)

	return new_entry_counts, new_entry_files

def processDirectory(directory, pattern):
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
				
				counts, files = processFile(file_path)

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


def getStandardDeviations(entry_counts: dict[str, list[int]]) -> dict[str, list[int]]:
	"""
	Return deviations.
	"""
	deviations = {}

	for key, counts in entry_counts.items():
		avg = sum(counts) / len(counts)
		deviations[key] = ( sum(abs(count - avg)**2 for count in counts) / (len(counts)-1) ) ** 0.5

	return deviations


if __name__ == "__main__":

	pattern = "report2.*\\.json"

	if len(sys.argv) != 2:
		print("Usage: average.py <directory>")
		sys.exit(1)

	directory = sys.argv[1]

	count, entry_counts, counts_avg = processDirectory(directory, pattern)
	std_deviations = getStandardDeviations(entry_counts)

	print("---\n---\n---")
	print(f"Average counts (files: {count}):")
	for key, value in counts_avg.items():
		print(f"{KEYS_REGEX[key]}: {value}")
	print("---")
	print(f"All counts (files: {count}):")
	for key, counts in entry_counts.items():
		print(f"{KEYS_REGEX[key]}: {str(counts)}")
	print("---")
	print(f"Standard deviations (files: {count}):")
	for key, value in std_deviations.items():
		print(f"{KEYS_REGEX[key]}: {value}")

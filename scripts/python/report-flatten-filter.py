#!/usr/bin/env python3

import json
import os
import re
import sys


KEYS_REGEX = {
	"tot_checksum" : "Tot: saved in checksum \\(filtered\\).*",
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

KEYS_REGEX_EXCLUDE = (
	"tot_checksum",
	"error_write_file",
	"error_delete_shard",
	"error_checksum",
	"error_insufficient_shards",
	"error_other",
	"stats",
)

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


def processFile(input_file, is_verbose=False):

	with open(input_file, 'r') as file:
		data = json.load(file)

	flattened = []

	# Function to extract inner elements recursively
	def extract_inner_elements(value):
		if isinstance(value, dict):
			if is_verbose:
				print(f"error, dict: {value}")
			return []
		elif isinstance(value, list):
			return list(
				map(
					lambda entry: {
						'path': str(entry['path']).lstrip('/mnt/win10/Users/IEUser/'),
						'checksum': entry['checksum'],
					},
					filter(
						lambda entry: isinstance(entry, dict) and entry['checksum'] not in ('null', None) and any(entry['path'].startswith(folder) for folder in FOLDERS),
						value
					)
				)
			)
		else:
			# Return non-dict, non-list values as is
			if is_verbose:
				print(f"error, other type: {value}")
			return []

	# Traverse through the original JSON and extract inner elements
	for key, value in data.items():
		if not any(re.match(KEYS_REGEX[regex_key], key) for regex_key in KEYS_REGEX_EXCLUDE):
			if is_verbose:
				print(f"Processing key: {key}")
			flattened.extend( extract_inner_elements(value) )

	return flattened


def getOutputFilePath(input_file):
	directory, filename = os.path.split(input_file)
	new_filename = 'flattened_filtered_' + filename
	return os.path.join(directory, new_filename)


if __name__ == "__main__":

	pattern = "report2.*"

	if len(sys.argv) < 2:
		print("Usage: report-flatten-filter.py [-v] <input.json>")
		sys.exit(1)

	file_input = sys.argv[1]
	file_output = getOutputFilePath(file_input)

	is_verbose = False
	if len(sys.argv) >= 2 and '-v' in sys.argv:
		is_verbose = True

	if is_verbose:
		print(f'input file: {file_input}')
		print(f'output file: {file_output}')

	flattened = processFile(file_input, is_verbose)

		# Save the result in a new JSON file
	with open(file_output, 'w') as file:
		json.dump(flattened, file, indent=4)

	# Output the new JSON data
	if is_verbose:
		print(json.dumps(flattened, indent=4))


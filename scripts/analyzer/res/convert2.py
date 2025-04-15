#/******************************************************************************
# * Copyright 2025 (C) by Daniele D'Ugo <danieledugo1@gmail.com>               *
# *                                                                            *
# * This program is free software; you can redistribute it and/or modify       *
# * it under the terms of the GNU Library General Public License as            *
# * published by the Free Software Foundation; either version 2 of the         *
# * License, or (at your option) any later version.                            *
# *                                                                            *
# * This program is distributed in the hope that it will be useful,            *
# * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
# * GNU General Public License for more details.                               *
# *                                                                            *
# * You should have received a copy of the GNU Library General Public          *
# * License along with this program; if not, write to the                      *
# * Free Software Foundation, Inc.,                                            *
# * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.                  *
# *                                                                            *
# * For details about the authors of this software, see the AUTHORS file.      *
# ******************************************************************************/


import json

def filter_json_by_folders(file_path, folders, output_file):
    # Read JSON file
    with open(file_path, "r", encoding="utf-8") as file:
        data = json.load(file)

    # Ensure data is a list (JSON array)
    if not isinstance(data, list):
        raise ValueError("Expected a JSON array at the root level.")

    # Filter objects where "path" exists in the given list of folders
    filtered_data = [entry for entry in data if isinstance(entry, dict) and any(entry["path"].startswith(folder) for folder in folders)]

    # Write filtered JSON back to file
    with open(output_file, "w", encoding="utf-8") as file:
        json.dump(filtered_data, file, indent=4)  # Pretty-print JSON


# Example usage
file_path = "cleanWindowsChecksum.json"   # Replace with your actual JSON file
output_file = "cleanWindowsChecksum_filtered.json"  # Replace with desired output file
folders = [                 # List of folder prefixes to keep
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

filter_json_by_folders(file_path, folders, output_file)

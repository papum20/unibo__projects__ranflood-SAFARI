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

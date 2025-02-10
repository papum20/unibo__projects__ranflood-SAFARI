import re
import json

def clean_json_file(file_path, in_place=False):
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Match { ... } blocks containing "path": "AppData"
    pattern = r"\{\s*[^{}]*\"path\":\s*\"AppData.*\"[^}]*\},?\s*"

    # Remove matching blocks and fix trailing commas
    modified_content = re.sub(pattern, "", content, flags=re.MULTILINE).strip()

    # Ensure we don’t leave a trailing comma in an array
    modified_content = re.sub(r",\s*(\]|\})", r"\1", modified_content)

    if in_place:
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(modified_content)
    else:
        print(modified_content)

# Example usage:
file_path = "cleanWindowsChecksum.json"  # Replace with your actual file path
clean_json_file(file_path, in_place=True)  # Change to True to modify the file

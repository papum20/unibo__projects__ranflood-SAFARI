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

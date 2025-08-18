
import sys
import os
import re
from enum import Enum

if len(sys.argv) != 2:
    print("Usage: python .util_extract_code_to_md.py <file_number>")
    sys.exit(1)

class Pos(Enum):
    LANGUAGE = 0
    DELIMITER = 1
    EXT = 2
    ON = 3

options = [
    [
        "cpp",
        "## cpp",
        "cpp",
        os.getenv("ENABLE_CPP", "false").lower() == "true"
    ],
    [
        "python",
        "## python",
        "py",
        os.getenv("ENABLE_PYTHON", "false").lower() == "true"
    ],
]

file_number = sys.argv[1]
output_path = os.path.join("boj", file_number, f"{file_number}.md")

def run(index):
    file_path = os.path.join(
        "boj", file_number, f"{file_number}.{options[index][Pos.EXT.value]}")

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    with open(output_path, 'r', encoding='utf-8') as f:
        found_my_code_section = False
        before_code_section = []
        after_code_section = []

        for line in f:
            if line.strip() == "# My Code":
                before_code_section.append(line)
                found_my_code_section = True
                continue
            if not found_my_code_section:
                before_code_section.append(line)
            else:
                after_code_section.append(line)

    delimiter = f"{options[index][Pos.DELIMITER.value]}"
    cleaned_after_code_section = []
    skip_mode = False

    for line in after_code_section:
        if not skip_mode:
            if delimiter in line:
                skip_mode = True
                continue
            else:
                cleaned_after_code_section.append(line)
        else:
            if line.strip() == "```":
                skip_mode = False

    insert_code = []
    insert_code.append(f"{delimiter}")
    insert_code.append(
        f"\n```{options[index][Pos.LANGUAGE.value]} title=\"boj/{file_number}.{options[index][Pos.EXT.value]}\"\n")
    insert_code.append(content)
    insert_code.append("\n```\n")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(before_code_section)
        f.writelines(insert_code)
        f.writelines(cleaned_after_code_section)

for i in range(len(options)):
    if options[i][Pos.ON.value] :
        run(i)

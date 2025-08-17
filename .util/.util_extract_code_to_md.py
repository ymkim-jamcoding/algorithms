
import sys
import os
import re
from enum import Enum


class Pos(Enum):
    LANGUAGE = 0
    DELIMITER = 1
    EXT = 2


options = [
    [
        "cpp",
        "## cpp",
        "cpp"
    ],
]


if len(sys.argv) != 2:
    print("Usage: python .util_extract_code_to_md.py <filenumber>")
    sys.exit(1)

# 추출 대상 파일 경로
file_number = sys.argv[1]
output_path = os.path.join("boj", file_number, f"{file_number}.md")


def run(index):
    # options[index]
    file_path = os.path.join(
        "boj", file_number, f"{file_number}.{options[index][Pos.EXT.value]}")

    # 파일 전체 읽기
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    with open(output_path, 'r', encoding='utf-8') as f:
        md_lines = []
        for line in f:
            md_lines.append(line)
            if line.strip().lower() == options[index][Pos.DELIMITER.value]:
                break  # 여기서 멈춤

    md_lines.append(
        f"\n```{options[index][Pos.LANGUAGE.value]} title=\"boj/{file_number}.{options[index][Pos.EXT.value]}\"\n")
    md_lines.append(content)
    md_lines.append("\n```\n")

    if index + 1 < len(options):
        md_lines.append(f"\n{options[index + 1][Pos.DELIMITER.value]}\n")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(md_lines)

for i in range(len(options)):
    run(i)

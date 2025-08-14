
import sys
import os
import re
from enum import Enum


class Pos(Enum):
    LANGUAGE = 0
    START_MARKER = 1
    END_MARKER = 2
    DELIMITER = 3
    EXT = 4


options = [
    [
        "cpp",
        r" \*------------------------------------------------------------------------------\n \*/\n",
        r"/\*\*\n \*------------------------------------------------------------------------------\n \*  /..*",
        "## cpp",
        "cpp"
    ],
]


if len(sys.argv) != 2:
    print("Usage: python extract.py <filenumber>")
    sys.exit(1)

# 추출 대상 파일 경로
file_number = sys.argv[1]
output_path = os.path.join(file_number, f"{file_number}.md")


def run(index):
    # options[index]
    file_path = os.path.join(
        file_number, f"{file_number}.{options[index][Pos.EXT.value]}")

    # 파일 전체 읽기
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 시작 위치 찾기
    start_match = re.search(options[index][Pos.START_MARKER.value], content)
    end_match = re.search(options[index][Pos.END_MARKER.value], content)

    code_between = ""

    if start_match and end_match:
        start_index = start_match.end()
        end_index = end_match.start()
        code_between = content[start_index:end_index]
    else:
        print(f"{options[index][Pos.LANGUAGE.value]} Markers not found.")

    with open(output_path, 'r', encoding='utf-8') as f:
        md_lines = []
        for line in f:
            md_lines.append(line)
            if line.strip().lower() == options[index][Pos.DELIMITER.value]:
                break  # 여기서 멈춤

    md_lines.append(
        f"\n```{options[index][Pos.LANGUAGE.value]} title=\"boj/{file_number}.{options[index][Pos.EXT.value]}\"\n")
    md_lines.append(code_between + "\n")
    md_lines.append("```\n")

    if index + 1 < len(options):
        md_lines.append(f"\n{options[index + 1][Pos.DELIMITER.value]}\n")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(md_lines)


for i in range(len(options)):
    run(i)

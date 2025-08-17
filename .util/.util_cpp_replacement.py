import re
import sys
import os 

if len(sys.argv) != 2:
    print("Usage: python .util/.util_cpp_replacement.py <file_number>")
    sys.exit(1)

file_number = sys.argv[1]
input_path = os.path.join("boj", file_number, f"{file_number}.cpp")
output_path = os.path.join("boj", file_number, f"_solve_{file_number}.cpp")
with open(input_path, "r") as f:
    code = f.read()

pattern = r'\bint\s+main\s*\('
code_new = re.sub(pattern, 'int _solve(', code)

with open(output_path, "w") as f:
    f.write(code_new)
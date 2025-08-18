import sys
import runpy
import subprocess

sys.setrecursionlimit(10**9)
input = sys.stdin.readline
output = sys.stdout.write

# def log(*args):
#     print(*args, file=sys.stderr)

def solve_module(path):
    runpy.run_path(path, run_name="__main__")

def run_test(problem_number, test_number):
    input_path = f"./boj/{problem_number}/t_{test_number}_input.txt"
    output_path = f"./boj/{problem_number}/t_{test_number}_output_mine.txt"
    script_path = f"./boj/{problem_number}/{problem_number}.py"

    import os
    if not os.path.exists(input_path):
        print(f"Input file not found: {input_path}", file=sys.stderr)
        return

    with open(output_path, "w") as fout:
        subprocess.run(
            ["python3", script_path],
            stdin=open(input_path, "r"),
            stdout=fout,
            stderr=subprocess.PIPE,
            text=True,
        )

if __name__ == "__main__":
    args = sys.argv
    if len(args) == 2:
        p = int(args[1])
        solve_module(f"./boj/{p}/{p}.py")
    elif len(args) == 3:
        p, t = map(int, args[1:])
        for i in range(1, t + 1):
            run_test(p, i)
    elif len(args) == 4:
        p, t, target = map(int, args[1:])
        if target == 0:
            for i in range(1, t + 1):
                run_test(p, i)
        else:
            run_test(p, target)

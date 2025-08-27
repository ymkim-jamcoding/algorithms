#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int _solve(void);

void _run_test(int problem_number, int test_number) {
  char test_input_file_name[256];
  char my_output_file_name[256];

  sprintf(test_input_file_name, "boj/%d/t_%d_input.txt", problem_number,
          test_number);
  sprintf(my_output_file_name, "boj/%d/t_%d_output_mine.txt", problem_number,
          test_number);

  FILE *in = fopen(test_input_file_name, "r");
  FILE *out = fopen(my_output_file_name, "w");

  if (!in || !out) {
    fprintf(stderr, "File open error: %s or %s\n", test_input_file_name,
            my_output_file_name);
    if (in)
      fclose(in);
    if (out)
      fclose(out);
    return;
  }

  FILE *orig_stdin = stdin;
  FILE *orig_stdout = stdout;

  stdin = in;
  stdout = out;

  _solve();

  stdin = orig_stdin;
  stdout = orig_stdout;

  fclose(in);
  fclose(out);
}

int main(int argc, char *argv[]) {
  if (argc < 3 || argc > 4) {
    fprintf(stderr, "Usage: %s <problem_number> <test_size> [test_target]\n",
            argv[0]);
    return -1;
  }

  int problem_number = atoi(argv[1]);
  int test_size = atoi(argv[2]);
  int test_target = (argc == 4) ? atoi(argv[3]) : 0;

  if (test_target == 0) {
    for (int i = 1; i <= test_size; i++) {
      _run_test(problem_number, i);
    }
  } else {
    _run_test(problem_number, test_target);
  }

  return 0;
}
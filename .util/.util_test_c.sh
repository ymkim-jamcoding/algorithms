#!/bin/bash
source .env

if ! $ENABLE_C; then
   exit 0;
fi

dir=$1
test_count=$2
target_test_number=$3
# -Wall -Wextra -Werror -Werror=return-type
flag="-Werror=return-type"

if ls boj/$dir/$dir.c >/dev/null 2>&1; then \
  if $ENABLE_AUTO_TEST; then
    if [[ "$target_test_number" == "i" ]]; then
      gcc -std=c17 ${flag} -o boj/$dir/$dir.out boj/$dir/$dir.c;
      ./boj/$dir/$dir.out;
      echo
      exit 0
    fi
  else
    gcc -std=c17 ${flag} -o boj/$dir/$dir.out boj/$dir/$dir.c
    ./boj/$dir/$dir.out
    echo
    exit 0
  fi

  if [ "$INIT_TEST" -ne 0 ] && ! ls boj/$dir/t_${INIT_TEST}_input.txt >/dev/null 2>&1; then \
    is_first=true
    first_value=0
    for i in $(seq 1 $INIT_TEST); do
      if ! ls boj/$dir/t_${i}_input.txt >/dev/null 2>&1; then 
        if $is_first; then
          is_first=false
          first_value=$i 
        fi
        touch boj/$dir/t_${i}_input.txt
        touch boj/$dir/t_${i}_output_.txt
        code boj/$dir/t_${i}_input.txt
        code boj/$dir/t_${i}_output_.txt
      fi
    done

    if ! $is_first; then
      code boj/$dir/t_${first_value}_input.txt
    fi

    echo
    .util/.util_function.sh 3 "yellow" "kr - 테스트 케이스를 각 번호에 맞게 직접 넣어요."
    exit 8
  fi

  if ! ls boj/$dir/t_1_input.txt >/dev/null 2>&1; then
    .util/.util_function.sh 1 $dir;
    exit 9
  fi

  echo;
  .util/.util_function.sh 3 "yellow" "[c - $dir]"
  if $ENABLE_AUTO_TEST; then
    if [[ "$target_test_number" -gt "$test_count" || "$target_test_number" -lt 0 ]]; then
      echo "$target_test_number is invalid target test number."
      .util/.util_function.sh 3 "yellow" "1 <= valid number <= $test_count"
      exit 9
    fi

    python3 .util/.util_c_replacement.py $dir;
    gcc -std=c17 ${flag} -o boj/$dir/$dir.out boj/$dir/_solve_$dir.c .util/.template_c_main.c;
    ./boj/$dir/$dir.out $dir $test_count $target_test_number;
    .util/.util_test_case_check.sh $dir $test_count $target_test_number;
    rm boj/$dir/_solve_$dir.c
  fi

else \
  cp my_c_template.c boj/$dir/$dir.c;

if [ "$(uname)" = "Darwin" ]; then
sed -i '' "1i\\
// https://www.acmicpc.net/problem/$dir
" boj/$dir/$dir.c
else
sed -i "1i\\
// https://www.acmicpc.net/problem/$dir
" boj/$dir/$dir.c
fi
fi


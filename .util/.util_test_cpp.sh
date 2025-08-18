#!/bin/bash
source .env

if ! $ENABLE_CPP; then
   exit 0;
fi

dir=$1
test_count=$2
target_test_number=$3

if ls boj/$dir/$dir.cpp >/dev/null 2>&1; then \
  if $ENABLE_AUTO_TEST; then
    if [[ "$target_test_number" == "i" ]]; then
      g++ -std=c++17 -Wall -Wextra -Werror -o boj/$dir/$dir.out boj/$dir/$dir.cpp;
      ./boj/$dir/$dir.out;
      echo
      exit 0
    fi
  else
    g++ -std=c++17 -Wall -Wextra -Werror -o boj/$dir/$dir.out boj/$dir/$dir.cpp
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
  echo "[cpp - $dir]";
  if $ENABLE_AUTO_TEST; then
    if [[ "$target_test_number" -gt "$test_count" || "$target_test_number" -lt 0 ]]; then
      echo "$target_test_number is invalid target test number."
      .util/.util_function.sh 3 "yellow" "1 <= valid number <= $test_count"
      exit 9
    fi

    python3 .util/.util_cpp_replacement.py $dir;
    g++ -std=c++17 -Wall -Wextra -Werror -o boj/$dir/$dir.out boj/$dir/_solve_$dir.cpp .util/.template_cpp_main.cpp;
    ./boj/$dir/$dir.out $dir $test_count $target_test_number;
    .util/.util_test_case_check.sh $dir $test_count $target_test_number;
    rm boj/$dir/_solve_$dir.cpp
  fi

else \
  cp my_cpp_template.cpp boj/$dir/$dir.cpp;

if [ "$(uname)" = "Darwin" ]; then
sed -i '' "1i\\
// https://www.acmicpc.net/problem/$dir
" boj/$dir/$dir.cpp
else
sed -i "1i\\
// https://www.acmicpc.net/problem/$dir
" boj/$dir/$dir.cpp
fi
fi


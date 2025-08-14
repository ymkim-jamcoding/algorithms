#!/bin/bash

dir=$1
test_count=$2
target_test_number=$3

if ls $dir/$dir.cpp >/dev/null 2>&1; then \

  if [ "$INIT_TEST" -ne 0 ] && ! ls $dir/test-input-$INIT_TEST.txt >/dev/null 2>&1; then \
    ./util_function.sh 2 $dir
    
    for i in $(seq 1 $INIT_TEST); do
      touch $dir/test-input-$i.txt
      code $dir/test-input-$i.txt
      touch $dir/test-output-$i.txt
      code $dir/test-output-$i.txt
    done
    code $dir/test-input-1.txt
    echo
    echo -e "\033[38;5;208mkr - 테스트 케이스를 각 번호에 맞게 직접 넣어요.\033[0m\n"
    exit 8
  fi

  if ! ls $dir/test-input-1.txt >/dev/null 2>&1; then
    ./util_function.sh 1 $dir
    exit 9
  fi

  echo
  echo "[cpp]"
  g++ -std=c++17 -Wall -Wextra -Werror -o $dir/$dir.out $dir/*.cpp; \
  $dir/$dir.out $dir $test_count $target_test_number; \
  ./util_test_case_check.sh $dir $test_count $target_test_number; \
  
else \
  cp template.cpp $dir/$dir.cpp;

if [ "$(uname)" = "Darwin" ]; then
sed -i '' "1i\\
// https://www.acmicpc.net/problem/$dir
" $dir/$dir.cpp
else
sed -i "1i\\
// https://www.acmicpc.net/problem/$dir
" $dir/$dir.cpp
fi
fi

echo

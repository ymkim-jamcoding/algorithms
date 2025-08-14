#!/bin/bash

dir=$1
test_count=$2
target_test_number=$3

if ls $dir/$dir.cpp >/dev/null 2>&1; then \
  echo
  echo "[cpp]"
  g++ -std=c++20 -Wall -Wextra -Werror -o $dir/$dir.out $dir/*.cpp; \
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

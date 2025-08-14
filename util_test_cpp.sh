#!/bin/bash

dir=$1
test_count=$2
target_test_number=$3

if ls $dir/$dir.cpp >/dev/null 2>&1; then \
  echo
  echo "[cpp]"
  if ls $dir/test-input-0.txt >/dev/null 2>&1; then
    echo -e "\033[38;5;208men - Failed to crawl the test cases. Please enter them manually into the file.\033[0m"
    echo -e "\033[38;5;208mkr - 테스트 케이스 크롤링에 실패 했어요. 직접 파일에 넣어주세요.\033[0m\n"
    exit 9
  fi
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

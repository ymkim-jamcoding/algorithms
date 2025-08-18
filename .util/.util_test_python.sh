#!/bin/bash
source .env

if ! $ENABLE_PYTHON; then
   exit 0;
fi

dir=$1
test_count=$2
target_test_number=$3

if ls boj/$dir/$dir.py >/dev/null 2>&1; then \

  if $ENABLE_AUTO_TEST; then
    if [[ "$target_test_number" == "i" ]]; then
      python3 .util/.template_python_main.py $dir; 
      echo
      exit 0
    fi
  else
    python3 .util/.template_python_main.py $dir; 
    echo
    exit 0
  fi

  if [ "$INIT_TEST" -ne 0 ] && ! ls boj/$dir/test-input-$INIT_TEST.txt >/dev/null 2>&1; then \
    is_first=true
    first_value=0
    for i in $(seq 1 $INIT_TEST); do
      if ! ls boj/$dir/test-input-$i.txt >/dev/null 2>&1; then 
        if $is_first; then
          is_first=false
          first_value=$i 
        fi
        touch boj/$dir/test-input-$i.txt
        touch boj/$dir/test-output-$i.txt
        code boj/$dir/test-input-$i.txt
        code boj/$dir/test-output-$i.txt
      fi
    done

    if ! $is_first; then
      code boj/$dir/test-input-$first_value.txt
    fi

    echo
    .util/.util_function 3 "yellow" "kr - 테스트 케이스를 각 번호에 맞게 직접 넣어요."
    exit 8
  fi

  if ! ls boj/$dir/test-input-1.txt >/dev/null 2>&1; then
    .util/.util_function.sh 1 $dir;
    exit 9
  fi

  echo;
  echo "[python - $dir]";
  if $ENABLE_AUTO_TEST; then

    if [[ "$target_test_number" -gt "$test_count" || "$target_test_number" -lt 0 ]]; then
      echo "$target_test_number is invalid target test number."
      .util/.util_function.sh 3 "yellow" "1 <= valid number <= $test_count"
      exit 9
    fi

    python3 .util/.template_python_main.py $dir $test_count $target_test_number
    .util/.util_test_case_check.sh $dir $test_count $target_test_number;
  fi

else \
  cp my_python_template.py boj/$dir/$dir.py;

if [ "$(uname)" = "Darwin" ]; then
sed -i '' "1i\\
# https://www.acmicpc.net/problem/$dir
" boj/$dir/$dir.py
else
sed -i "1i\\
# https://www.acmicpc.net/problem/$dir
" boj/$dir/$dir.py
fi
fi

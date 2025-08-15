#!/bin/bash

case=$1
number=$2

case $case in
  1)
    echo
    echo -e "\033[31;5;208mkr - 테스트 케이스 크롤링에 실패 했어요. 다음 절차를 따라주세요.\033[0m\n"
    echo
    echo -e "테스트 개수를 다음 커맨드에 따라 입력해요. (개수만큼 테스트 파일이 만들어져요.)\n\n\033[38;5;208m\n\t\tmake $number i=[테스트 개수]\033[0m\n\n"
    echo -e "ex) make $number i=3"
    echo -e "    - $number 문제에 대해서 3개의 테스트 케이스 파일을 만들어줘요."
    echo
    ;;
  2)
    code --goto boj/$number/$number.cpp:40
    code --goto boj/$number/$number.md:10
    ;;
  3|4)
    echo "234"
    ;;
  *)
    echo ""
    ;;
esac

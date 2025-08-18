#!/bin/bash
source .env

YELLOW="\033[38;5;208m"
GREEN="\033[38;5;34m"
RED="\033[38;5;196m"
RESET="\033[0m"

case=$1
number=$2
string=$3

color_echo(){
  local color="$1"
  local msg="$2"

  if [ "$color" = "yellow" ]; then
    echo -e "${YELLOW} ${msg} ${END}"
  elif [ "$color" = "green" ]; then
    echo -e "${GREEN} ${msg} ${END}"
  elif [ "$color" = "red" ]; then
    echo -e "${RED} ${msg} ${END}"
  else
    echo "${msg}"
  fi
}

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
    if $ENABLE_CPP; then
      code --goto boj/$number/$number.cpp
    fi

    if $ENABLE_PYTHON; then
      code --goto boj/$number/$number.py
    fi

    if $ENABLE_MARKDOWN; then
      code --goto boj/$number/$number.md
    fi
    ;;
  3)
    color_echo "$number" "$string"
    ;;
  *)
    echo ""
    ;;
esac

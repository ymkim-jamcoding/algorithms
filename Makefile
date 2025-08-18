
RAW_GOALS := $(MAKECMDGOALS)
dir := $(word 1, $(RAW_GOALS))
t := $(test)
i := 0
test_count := $(shell ls boj/$(dir)/test-output-*.txt 2>/dev/null | wc -l)

YELLOW := \033[38;5;208m
GREEN := \033[38;5;34m
RED := \033[38;5;196m
RESET := \033[0m

IGNORED_TARGETS := all push clean run help pull

SRCS=$(wildcard boj/$(dir)/*.cpp)

DATE := $(shell TZ=Asia/Seoul date '+%Y-%m-%d %H:%M')
m ?= $(DATE)

override MAKECMDGOALS := $(word 1, $(RAW_GOALS))

.PHONY: all push clean help pull $(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS))

all: help

pull:
	git pull

push:
	git add .
	git commit -m "$(m)"
	git push

help:
	@echo "make"
	@echo "make help"
	@echo
	@echo "$(RED)수동 컴파일 && 실행 방법$(RESET)"
	@echo "         - g++ -std=c++17 -Wall -Wextra -Werror -o answer.out {my_code_file.cpp} && ./answer.out"
	@echo
	@echo "$(YELLOW)make pull$(RESET)"
	@echo "         - Pull updates from the repository"
	@echo
	@echo "$(YELLOW)make push$(RESET)"
	@echo "         - Push changes with current date and time as commit message"
	@echo
	@echo "$(YELLOW)make push m=\"[string]\"$(RESET)"
	@echo "         - Push changes with a custom commit message"
	@echo
	@echo "$(GREEN)make [p_number]$(RESET)"
	@echo "         - boj problem number (e.g., 18111) to create a directory and files"
	@echo "         - Run all tests for [p_number] problem"
	@echo
	@echo "$(GREEN)make [p_number] t=[t_number | i]$(RESET)"
	@echo "         - Run test case [t_number]"
	@echo "         - When \"t=i\", manual mode lets you enter test cases directly"
	@echo
	@echo "$(GREEN)make [p_number] i=[i_number]$(RESET)"
	@echo "         - Create test case files numbered 1 to [i_number]"
	@echo "         - Run all tests for [p_number] problem"

$(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS)):
	@echo "addr - https://boj.kr/$(dir)";

	@if [ -d "boj/$(dir)" ]; then \
		INIT_TEST=$(i) .util/.util_test_cpp.sh $(dir) $(test_count) $(t); \
		INIT_TEST=$(i) .util/.util_test_python.sh $(dir) $(test_count) $(t); \
		.util/.util_make_md.sh $(dir); \
	else \
		mkdir -p boj/$(dir);\
		.util/.util_test_cpp.sh $(dir) $(test_count) $(t); \
		.util/.util_test_python.sh $(dir) $(test_count) $(t); \
		.util/.util_make_md.sh $(dir); \
		.util/.util_get_test_case.sh $(dir) true;\
	fi

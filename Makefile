
RAW_GOALS := $(MAKECMDGOALS)
dir := $(word 1, $(RAW_GOALS))
t := $(test)
i := 0
test_count := $(shell ls $(dir)/test-output-*.txt 2>/dev/null | wc -l)

YELLOW := \033[38;5;208m
GREEN := \033[38;5;34m
RED := \033[38;5;196m
RESET := \033[0m

IGNORED_TARGETS := all push clean run help pull sync

SRCS=$(wildcard $(dir)/*.cpp)

DATE := $(shell TZ=Asia/Seoul date '+%Y-%m-%d %H:%M')
m ?= $(DATE)

override MAKECMDGOALS := $(word 1, $(RAW_GOALS))

.PHONY: all push clean help pull sync $(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS))

all: help

sync: pull

pull:
	git pull

push:
	git add .
	git commit -m "$(m)"
	git push

help:
	@echo "가능한 명령어"
	@echo
	@echo "make"
	@echo "make help"
	@echo
	@echo
	@echo "$(YELLOW)make pull$(RESET)"
	@echo "$(YELLOW)make sync$(RESET)"
	@echo "         - Pull updates from the repository"
	@echo
	@echo "$(YELLOW)make push$(RESET)"
	@echo "         - Push changes with current date and time as commit message"
	@echo
	@echo "$(YELLOW)make push m=\"[string]\"$(RESET)"
	@echo "         - Push changes with a custom commit message"
	@echo
	@echo
	@echo "$(GREEN)make [p_number]$(RESET)"
	@echo "         - boj problem number (e.g., 18111) to create a directory and files"
	@echo "         - Run all tests for [p_number] problem"
	@echo
	@echo "$(GREEN)make [p_number] t=[t_number]$(RESET)"
	@echo "         - Run test case [t_number]"
	@echo
	@echo "$(GREEN)make [p_number] i=[i_number]$(RESET)"
	@echo "         - Create test case files numbered 1 to [i_number]"
	@echo "         - Run all tests for [p_number] problem"
	@echo

$(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS)):
	@echo "addr - https://boj.kr/$(dir)";

	@if [ -d "$(dir)" ]; then \
		INIT_TEST=$(i) ./.util_test_cpp.sh $(dir) $(test_count) $(t); \
		./.util_make_md.sh $(dir); \
	else \
		mkdir -p $(dir);\
		./.util_test_cpp.sh $(dir) $(test_count) $(t); \
		./.util_make_md.sh $(dir); \
		./.util_get_test_case.sh $(dir) true;\
	fi

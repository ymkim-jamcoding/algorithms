
RAW_GOALS := $(MAKECMDGOALS)
dir := $(word 1, $(RAW_GOALS))
t := $(test)
test_count := $(shell ls $(dir)/test-output-*.txt 2>/dev/null | wc -l)

YELLOW := \033[38;5;208m
GREEN := \033[38;5;34m
RED := \033[38;5;196m
RESET := \033[0m

IGNORED_TARGETS := all push clean run help

SRCS=$(wildcard $(dir)/*.cpp)

DATE := $(shell TZ=Asia/Seoul date '+%Y-%m-%d %H:%M')
m ?= $(DATE)

override MAKECMDGOALS := $(word 1, $(RAW_GOALS))

.PHONY: all push clean help $(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS))

all: help

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
	@echo "$(YELLOW)make push$(RESET)"
	@echo "         - Push changes with current date and time as commit message"
	@echo
	@echo "$(YELLOW)make push m=\"[string]\"$(RESET)"
	@echo "         - Push changes with a custom commit message"
	@echo
	@echo
	@echo "$(GREEN)make [number]$(RESET)"
	@echo "         - boj problem number (e.g., 18111) to create a directory and files"
	@echo "         - run all tests for that problem"
	@echo
	@echo "$(GREEN)make [number] t=[number]$(RESET)"
	@echo "         - run specific test case"

$(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS)):
	@echo "addr - https://boj.kr/$(dir)";

	@if [ -d "$(dir)" ]; then \
		./util_test_cpp.sh $(dir) $(test_count) $(t); \
		./util_make_md.sh $(dir); \
	else \
		mkdir -p $(dir);\
		./util_test_cpp.sh $(dir) $(test_count) $(t); \
		./util_make_md.sh $(dir); \
		./util_get_test_case.sh $(dir) true;\
		code $(dir)/$(dir).md;\
		code $(dir)/$(dir).cpp;\
	fi

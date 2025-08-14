
RAW_GOALS := $(MAKECMDGOALS)
dir := $(word 1, $(RAW_GOALS))
target_test_number := $(test)
test_count := $(shell ls $(dir)/test-output-*.txt 2>/dev/null | wc -l)

IGNORED_TARGETS := all push clean run

SRCS=$(wildcard $(dir)/*.cpp)

DATE := $(shell TZ=Asia/Seoul date '+%Y-%m-%d %H:%M')
m ?= $(DATE)

override MAKECMDGOALS := $(word 1, $(RAW_GOALS))

.PHONY: all push clean $(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS))

all:
	@echo "Default build"

push:
	git add .
	git commit -m "$(m)"
	git push

$(filter-out $(IGNORED_TARGETS), $(MAKECMDGOALS)):
	@echo "addr - https://boj.kr/$(dir)";

	@if [ -d "$(dir)" ]; then \
		./util_test_cpp.sh $(dir) $(test_count) $(target_test_number); \
		./util_make_md.sh $(dir); \
	else \
		mkdir -p $(dir);\
		./util_test_cpp.sh $(dir) $(test_count) $(target_test_number); \
		./util_make_md.sh $(dir); \
		./util_get_test_answer.sh $(dir) true;\
		code $(dir)/$(dir).md;\
		code $(dir)/$(dir).cpp;\
	fi

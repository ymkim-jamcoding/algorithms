#!/bin/bash
source .env

problem_number=$1
test_case=$2
test_target=$3

correct_count=0

if [ -n "$test_target" ]; then
    if diff -b "boj/$problem_number/t_${test_target}_output_.txt" "boj/$problem_number/t_${test_target}_output_mine.txt" >/dev/null; then
        echo -e "Test case $test_target: \033[32mO\033[0m"
    else
        echo -e "Test case $test_target: \033[31mX\033[0m"
    fi

    if $ENABLE_PRINT_AUTO_TEST_OUTPUT; then
        cat "boj/$problem_number/t_${test_target}_output_mine.txt";
    fi
else
    for i in $(seq 1 $test_case); do
        if diff -b "boj/$problem_number/t_${i}_output_.txt" "boj/$problem_number/t_${i}_output_mine.txt" >/dev/null; then
            echo -e "Test case $i: \033[32mO\033[0m"
            ((correct_count++))
        else
            echo -e "Test case $i: \033[31mX\033[0m"
        fi

        if $ENABLE_PRINT_AUTO_TEST_OUTPUT; then
            cat "boj/$problem_number/t_${i}_output_mine.txt";
        fi
    done
    echo "- $correct_count/$test_case";
fi

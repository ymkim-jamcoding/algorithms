#!/bin/bash

url_number=$1
is_test=$2
url="https://www.acmicpc.net/problem/$url_number"

html=$(curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" $url)

# echo $html
count=$(echo $html | grep -o 'sample-output-' | wc -l)
count=$(expr $count / 2)

for i in $(seq 1 $count); do
    result=$(echo $html | perl -0777 -ne "print \$1 if /<pre class=\"sampledata\" id=\"sample-input-$i\">(.*?)<\/pre>/s")
    if [ "$is_test" == "true" ]; then
        echo $result >$url_number/test-input-$i.txt
    else
        echo $result
    fi

    # result=$(echo $html | perl -0777 -ne "print \$1 if /<pre class=\"sampledata\" id=\"sample-output-$i\">(.*?)<\/pre>/s" | sed 's/<[^>]*>//g')
    result=$(echo $html | perl -0777 -ne "print \$1 if /<pre class=\"sampledata\" id=\"sample-output-$i\">(.*?)<\/pre>/s")
    if [ "$is_test" == "true" ]; then
        echo $result >$url_number/test-output-$i.txt
    else
        echo $result
    fi
done

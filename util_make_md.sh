#!/bin/bash

set -e

url_number=$1
url="https://www.acmicpc.net/problem/$url_number"

get_boj_tier() {
    case "$1" in
    0) echo "unrated" ;;
    1) echo "bronze/5" ;;
    2) echo "bronze/4" ;;
    3) echo "bronze/3" ;;
    4) echo "bronze/2" ;;
    5) echo "bronze/1" ;;
    6) echo "silver/5" ;;
    7) echo "silver/4" ;;
    8) echo "silver/3" ;;
    9) echo "silver/2" ;;
    10) echo "silver/1" ;;
    11) echo "gold/5" ;;
    12) echo "gold/4" ;;
    13) echo "gold/3" ;;
    14) echo "gold/2" ;;
    15) echo "gold/1" ;;
    16) echo "platinum/5" ;;
    17) echo "platinum/4" ;;
    18) echo "platinum/3" ;;
    19) echo "platinum/2" ;;
    20) echo "platinum/1" ;;
    21) echo "diamond/5" ;;
    22) echo "diamond/4" ;;
    23) echo "diamond/3" ;;
    24) echo "diamond/2" ;;
    25) echo "diamond/1" ;;
    26) echo "ruby/5" ;;
    27) echo "ruby/4" ;;
    28) echo "ruby/3" ;;
    29) echo "ruby/2" ;;
    30) echo "ruby/1" ;;
    *) echo "unknown" ;;
    esac
}

get_boj_tier_name() {
    local n="$1"
    if [ "$n" -eq 0 ]; then
        echo "unrated"
    elif [ "$n" -le 5 ]; then
        echo "bronze"
    elif [ "$n" -le 10 ]; then
        echo "silver"
    elif [ "$n" -le 15 ]; then
        echo "gold"
    elif [ "$n" -le 20 ]; then
        echo "platinum"
    elif [ "$n" -le 25 ]; then
        echo "diamond"
    elif [ "$n" -le 30 ]; then
        echo "ruby"
    else
        echo "unknown"
    fi
}

get_boj_level() {
    local tier=$(get_boj_tier $1)
    local only_tier=$(get_boj_tier_name $1)
    echo "\"$2$tier\", \"$2$only_tier\""
}

get_tags_with_boj() {
    local prefix_level="ps/boj/"
    local prefix_tag="cs/algorithms/"
    local surfix_tag="/ps"

    local problem_id=$1
    local api_url="https://solved.ac/api/v3/problem/show?problemId=$problem_id"

    local response=$(curl -s --request GET \
        --url "$api_url" \
        --header 'Accept: application/json' \
        --header 'x-solvedac-language: ko')

    local level=$(get_boj_level $(echo "$response" | jq -r '.level') $prefix_level)
    local list=$(
        echo "$response" | jq -r '[.tags[]
        | .displayNames[]
        | select(.language == "en")
        | .name
        | gsub(" |_|-"; "-")
        ]'
    )

    local tags=$(echo "$list" | jq -r --arg prefix "$prefix_tag" --arg suffix "$surfix_tag" 'map("\($prefix)" + . + "\($suffix)") | map("\"" + . + "\"")| join(",")')

    echo "$level, $tags"
}

insert_boj_label() {
    local problem_id=$url_number
    local md_path="$problem_id/$problem_id.md"
    local tags=$(echo $(get_tags_with_boj $url_number))

    sed -i '' "2i\\
tags: [$tags]
" "$md_path"
}

copy_template_md() {
    cp template.md "$url_number/$url_number.md"
}

insert_boj_url() {
    sed -i '' "5i\\
- [$url]($url)
" $url_number/$url_number.md
}

if [ ! -e "$url_number/$url_number.md" ]; then
    copy_template_md
    insert_boj_url
    insert_boj_label
fi

python3 util_extract_code_to_md.py $url_number

#!/bin/bash

ROOT=$(dirname "$0")
ROOT=$(cd "$ROOT"; pwd)
file="${ROOT}/_posts/Papers.md"
items=("table" tbody "thead" "tr" "th" "td" "a" "li" "ul" "code")

function echo_red() {
    tput setaf 1; tput bold; echo "$@"; tput sgr0
}

function echo_green() {
    tput setaf 2; echo "$@"; tput sgr0
}


declare -A left_count=()
declare -A right_count=()

for item in ${items[@]}
do
    left_count[${item}]=0
    right_count[${item}]=0
done

for item in ${items[@]}
do
    ((left_count[${item}]=$(cat ${file} | grep -o -E "(<${item}>)|(<${item} )" | wc -l)))
    ((right_count[${item}]=$(cat ${file} | grep -o "</${item}>" | wc -l)))
done

for item in ${items[@]}
do
    if [ ${left_count[${item}]} -ne ${right_count[${item}]} ]; then
        echo_red "'${item}' not match, ${left_count[${item}]}/${right_count[${item}]}"
    else
        echo_green "'${item}' matches, ${left_count[${item}]}/${right_count[${item}]}"
    fi
done
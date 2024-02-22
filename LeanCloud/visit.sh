#!/bin/bash

function say() {
    tput setaf 1
    tput bold
    echo $@;
    tput sgr0
}

TEMP=`getopt -o '' --long 'file:,times:' -- "$@"`

if [ $? != 0 ] ; then 
    say "Failed to parse params"
    exit 1
fi

# 重新设置参数 
eval set -- "$TEMP"

URL_FILE="/root/url.list"
VISIT_TIMES=20

while true ; do
    case "$1" in
        --file) URL_FILE=$2; shift 2 ;;
        --times) VISIT_TIMES=$2 ; shift 2 ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [ ! -f ${URL_FILE} ]; then
    say "file '${URL_FILE}' not exist"
    exit 1
fi

URLS=( $(cat ${URL_FILE}) )

for ((i=0;i<VISIT_TIMES;i++)) 
do
    URL_COUNT=0
    for URL in ${URLS[@]}
    do
        say "total_visit_times: ${VISIT_TIMES}, visit_count: ${i}, total_urls=${#URLS[@]}, url_count=${URL_COUNT}"
        google-chrome --headless --disable-gpu --no-sandbox ${URL} >> log.log 2>&1
        ((URL_COUNT++))
    done
done
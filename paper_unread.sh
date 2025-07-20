#!/bin/bash

ROOT=$(dirname "$0")
ROOT=$(cd "$ROOT"; pwd)

FILE_PATHS=$(find ${ROOT}/resources/paper -name "*.pdf" | sort)
declare -A WHITE_DICT
WHITE_DICT["How-to-Read-a-Paper.pdf"]="1"

READ_COUNT=0
UNREAD_COUNT=0
for FILE_PATH in ${FILE_PATHS[@]}
do
    FILE_RESOURCE_PATH="/resources/paper/${FILE_PATH#*/resources/paper/}"
    
    if ! grep "<a href=\"${FILE_RESOURCE_PATH}\">" ${ROOT}/_posts/Papers.md > /dev/null 2>&1; then
        ((++UNREAD_COUNT))
        FILE_NAME=${FILE_PATH##*/}
        if [[ ! -v WHITE_DICT["${FILE_NAME}"] ]]; then
            echo "${UNREAD_COUNT}: ${FILE_NAME}"
        fi
    else
        ((++READ_COUNT))
    fi
done

echo "READ_COUNT: ${READ_COUNT}, UNREAD_COUNT: ${UNREAD_COUNT}"
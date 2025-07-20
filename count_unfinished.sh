#!/bin/bash

ROOT=$(dirname "$0")
ROOT=$(cd "$ROOT"; pwd)

FILES=$(find ${ROOT}/_posts -name "*.md")

for FILE in ${FILES}
do
    LINE=$(cat $FILE | wc -l)
    if [ $LINE -lt 30 ]
    then
        echo $FILE
    fi
done


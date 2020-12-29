#!/bin/bash

FILES=$(find . -name "*.md")

for FILE in ${FILES}
do
    LINE=$(cat $FILE | wc -l)
    if [ $LINE -lt 30 ]
    then
        echo $FILE
    fi
done


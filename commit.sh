#!/bin/bash

description="version["$(date +%Y)"."$(date +%m)"."$(date +%d)"#"$(date +%H:%M:%S)"]"


NAME=$(hostname)

echo "Hello, $NAME"

if [ "${NAME}" == 'ChenfengHe' ]
then
    git add .
    git commit -m $description
    git push origin master:master
else
    echo "Sorry ${NAME}, you cannot commit&push"
fi



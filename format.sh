#! /bin/bash

git status
java -Djava.ext.dirs=./lib org.liuyehcf.markdown.format.HexoFormatter . $1

#! /bin/bash

git status
java -jar lib/markdown-format.jar hexo . _posts
java -jar lib/markdown-format.jar normal . _unposts
java -jar lib/markdown-format.jar normal . _unposts/codebase
java -jar lib/markdown-format.jar normal . explore

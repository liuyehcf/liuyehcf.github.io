#! /bin/bash

git status
java -jar lib/markdown-format.jar hexo . _posts
java -jar lib/markdown-format.jar hexo . _unposts

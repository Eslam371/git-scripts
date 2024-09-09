@echo off

git fetch origin > NUL 2> tb-push.log

git checkout master > NUL 2> tb-push.log

git pull > NUL 2> tb-push.log

git checkout -b %1 origin/master > NUL 2> tb-push.log

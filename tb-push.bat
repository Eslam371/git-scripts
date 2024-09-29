@echo off

ping github.com -n 1 > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo error: unable to connect to github
    exit /b 1
)

for /f "delims=" %%i in ('git branch --show-current') do set branch_name=%%i
if "%branch_name%"=="master" (
    echo error: invalid branch, you are on master.
    exit /b 1
) else if "%branch_name%"=="staging" (
    echo error: invalid branch, you are on staging.
    exit /b 1
) else if "%branch_name%"=="develop" (
    echo error: invalid branch, you are on develop.
    exit /b 1
)


@REM ============================================================================================
@REM remove '-staging'/'-dev' from branch name to make sure we are on the master feature branch
@REM ============================================================================================
@REM Check if the string ends with -staging
if "%branch_name:~-8%"=="-staging" (
    set branch_name=%branch_name:~0,-8%
)

@REM Check if the string ends with -dev
if "%branch_name:~-4%"=="-dev" (
    set branch_name=%branch_name:~0,-4%
)

@REM ====================================
echo info: updating local master...
@REM ====================================
git checkout master > NUL 2>tb-push.log
git pull origin master > NUL 2>tb-push.log
if %errorlevel% neq 0 (
    echo error: solve merge conflicts between master and origin/master
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)

@REM ====================================
echo info: syncing %branch_name% with master...
@REM ====================================
git checkout %branch_name% > NUL 2> tb-push.log
git merge master --no-edit > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo error: solve merge conflicts between origin/master and %branch_name%
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)

@REM ====================================
echo info: pushing %branch_name%...
@REM ====================================
git push -u origin %branch_name% > NUL 2> tb-push.log


@REM ====================================
echo info: bringing changes into staging branch...
@REM ====================================
git branch %branch_name%-staging > NUL 2> tb-push.log
git checkout %branch_name%-staging > NUL 2> tb-push.log
git merge %branch_name% --no-edit > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo error: solve merge conflicts between %branch_name%-staging and %branch_name%
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)

@REM ====================================
echo info: updating local staging...
@REM ====================================
git checkout staging > NUL 2> tb-push.log
git pull --no-edit origin staging > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo error: solve merge conflicts between staging and origin/staging
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)


@REM ====================================
echo info: syncing %branch_name%-staging with staging...
@REM ====================================
git checkout %branch_name%-staging > NUL 2> tb-push.log
git merge staging --no-edit > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo error: solve merge conflicts between %branch_name%-staging and staging
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)

@REM ====================================
echo info: pushing %branch_name%-staging...
@REM ====================================
git push -u origin %branch_name%-staging > NUL 2> tb-push.log


@REM ====================================
echo info: bringing changes into dev branch...
@REM ====================================
git checkout %branch_name% > NUL 2> tb-push.log
git branch %branch_name%-dev > NUL 2> tb-push.log
git checkout %branch_name%-dev > NUL 2> tb-push.log
git merge %branch_name% --no-edit > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo solve merge conflicts between %branch_name%-dev and %branch_name%
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)

@REM ====================================
echo info: updating local develop...
@REM ====================================
git checkout develop > NUL 2> tb-push.log
git pull --no-edit origin develop > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo error: solve merge conflicts between origin/develop and develop
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)

@REM ====================================
echo info: syncing %branch_name%-dev with develop...
@REM ====================================
git checkout %branch_name%-dev > NUL 2> tb-push.log
git merge develop --no-edit > NUL 2> tb-push.log
if %errorlevel% neq 0 (
    echo error: solve merge conflicts between %branch_name%-dev and develop
    git merge --abort > NUL 2> tb-push.log
    git reset --merge > NUL 2> tb-push.log
    exit /b 1
)

@REM ====================================
echo info: pushing %branch_name%-dev...
@REM ====================================
git push -u origin %branch_name%-dev > NUL 2> tb-push.log

git checkout %branch_name% > NUL 2> tb-push.log

echo info: done.

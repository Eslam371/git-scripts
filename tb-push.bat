@echo off

for /f "delims=" %%i in ('git branch --show-current') do set branch_name=%%i

@REM ====================================
echo "info: updating local master..."
@REM ====================================
git checkout master
git pull origin master
if %errorlevel% neq 0 (
    echo.
    echo "error: solve merge conflicts between master and origin/master"
    git merge --abort
    git reset --merge
    exit /b 1
)

@REM ====================================
echo "info: syncing %branch_name% with master..."
@REM ====================================
git checkout %branch_name%
git merge master --no-edit
if %errorlevel% neq 0 (
    echo.
    echo "error: solve merge conflicts between %branch_name% and origin/master"
    git merge --abort
    git reset --merge
    exit /b 1
)

@REM ====================================
echo "info: pushing %branch_name%..."
@REM ====================================
git push -u origin %branch_name%


@REM ====================================
echo "info: bringing changes into staging branch..."
@REM ====================================
git branch %branch_name%-staging
git checkout %branch_name%-staging
git merge %branch_name% --no-edit
if %errorlevel% neq 0 (
    echo.
    echo "error: solve merge conflicts between %branch_name%-staging and %branch_name%"
    git merge --abort
    git reset --merge
    exit /b 1
)

@REM ====================================
echo "info: updating local staging..."
@REM ====================================
git checkout staging
git pull --no-edit origin staging
if %errorlevel% neq 0 (
    echo.
    echo "error: solve merge conflicts between staging and origin/staging"
    git merge --abort
    git reset --merge
    exit /b 1
)


@REM ====================================
echo "info: syncing %branch_name%-staging with staging..."
@REM ====================================
git checkout %branch_name%-staging
git merge staging --no-edit
if %errorlevel% neq 0 (
    echo.
    echo "error: solve merge conflicts between %branch_name%-staging and staging"
    git merge --abort
    git reset --merge
    exit /b 1
)

@REM ====================================
echo "info: pushing %branch_name%-staging..."
@REM ====================================
git push -u origin %branch_name%-staging


@REM ====================================
echo "info: bringing changes into dev branch..."
@REM ====================================
git checkout %branch_name%
git branch %branch_name%-dev
git checkout %branch_name%-dev
git merge %branch_name% --no-edit
if %errorlevel% neq 0 (
    echo.
    echo "solve merge conflicts between %branch_name%-dev and %branch_name%"
    git merge --abort
    git reset --merge
    exit /b 1
)

@REM ====================================
echo "info: updating local develop..."
@REM ====================================
git checkout develop
git pull --no-edit origin develop
if %errorlevel% neq 0 (
    echo.
    echo "error: solve merge conflicts between origin/develop and develop"
    git merge --abort
    git reset --merge
    exit /b 1
)

@REM ====================================
echo "info: syncing %branch_name%-dev with develop..."
@REM ====================================
git checkout %branch_name%-dev
git merge develop --no-edit
if %errorlevel% neq 0 (
    echo.
    echo "error: solve merge conflicts between %branch_name%-dev and develop"
    git merge --abort
    git reset --merge
    exit /b 1
)

@REM ====================================
echo "info: pushing %branch_name% develop..."
@REM ====================================
git push -u origin %branch_name%-dev

git checkout %branch_name%

echo ".======== DONE ========."
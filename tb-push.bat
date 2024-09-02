for /f "delims=" %%i in ('git branch --show-current') do set branch_name=%%i

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name% and origin/master"
git merge master --no-edit
git push -u origin %branch_name%

git branch %branch_name%-staging
git checkout %branch_name%-staging

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name%-staging and %branch_name%"
git merge %branch_name% --no-edit


git checkout staging
@REM check for conflicts => if yes abort with error "solve merge conflicts between staging and origin/staging"
git pull --no-edit origin staging
git checkout %branch_name%-staging

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name%-staging and staging"
git merge staging --no-edit

git push -u origin %branch_name%-staging

git checkout %branch_name%
git branch %branch_name%-dev
git checkout %branch_name%-dev

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name% and %branch_name%-dev"
git merge %branch_name% --no-edit

git checkout develop

@REM check for conflicts => if yes abort with error "solve merge conflicts between develop and origin/develop"
git pull --no-edit origin develop

git checkout %branch_name%-dev

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name%-dev and develop"
git merge develop --no-edit

git push -u origin %branch_name%-dev

git checkout %branch_name%
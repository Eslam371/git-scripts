for /f "delims=" %%i in ('git branch --show-current') do set branch_name=%%i

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name% and origin/master"
git merge master
git push -u origin %branch_name%

git branch %branch_name%-staging
git checkout %branch_name%-staging

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name%-staging and %branch_name%"
git merge %branch_name%


git checkout staging
@REM check for conflicts => if yes abort with error "solve merge conflicts between staging and origin/staging"
git pull origin staging
git checkout %branch_name%-staging

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name%-staging and staging"
git merge staging

git push -u origin %branch_name%-staging

git checkout %branch_name%
git branch %branch_name%-dev
git checkout %branch_name%-dev

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name% and %branch_name%-dev"
git merge %branch_name%

git checkout develop

@REM check for conflicts => if yes abort with error "solve merge conflicts between develop and origin/develop"
git pull origin develop

git checkout %branch_name%-dev

@REM check for conflicts => if yes abort with error "solve merge conflicts between %branch_name%-dev and develop"
git merge develop

git push -u origin %branch_name%-dev

git checkout %branch_name%
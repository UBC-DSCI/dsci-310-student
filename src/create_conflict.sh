# adapted from https://github.com/chendaniely/2022-08-03-cc2022-git#conflicts
# (Daniel Chen 2022)

mkdir dsci-310-assign2
cd dsci-310-assign2
git init
echo "# DSCI 310 Individual Assignment 2" >> README.md
git add README.md
git commit -m "Changes to main"
git branch -M main
git remote add origin $1
git push origin main

git checkout -b branch_1
echo "Changes to branch_1 commit 1" >> README.md
git status
git add README.md
git commit -m "branch_1 commit 1"
echo "Changes to branch_1 commit 2" >> README.md
git add README.md
git commit -m "branch_1 commit 2"

git checkout main

git checkout -b branch_2
echo "Changes to branch_2 commit 1" >> README.md
git add README.md
git commit -m "branch_2 commit 1"
echo "Changes to branch_2 commit 2" >> README.md
git add README.md
git commit -m "branch_2 commit 2"

git push origin branch_2
git push origin branch_1

git branch --set-upstream-to=origin/main main

cd ..
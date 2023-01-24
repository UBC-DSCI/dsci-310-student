#! /bin/bash

# adapted from https://github.com/chendaniely/2022-08-03-cc2022-git#conflicts
# (Daniel Chen 2022)
# Used for DSCI 310 Individual Assignemnt 2
# Not all students will have the dsci-310-student repo cloned on their computer,
# better to link to this file for students to download
# script will assume script is already in the assignment 2

echo "This script may or may not ask for your PAT multiple times...\n"

echo "Setting up main branch"
echo "\n# DSCI 310 Individual Assignment 2\n" >> README.md
git status
git add README.md
git status
git commit -m "Changes to main"
git status
git branch -M main
git push origin main:main
git status

echo "Setting up branch 1"
git checkout -b branch_1
git status
echo "Changes to branch_1 commit 1" >> README.md
git status
git add README.md
git status
git commit -m "branch_1 commit 1"
git status
echo "Changes to branch_1 commit 2" >> README.md
git status
git add README.md
git status
git commit -m "branch_1 commit 2"
git status
git push origin branch_1:branch_1
git status

echo "Setting up branch 2"

git checkout main
git status

git checkout -b branch_2
git status
echo "Changes to branch_2 commit 1" >> README.md
git status
git add README.md
git status
git commit -m "branch_2 commit 1"
git status
echo "Changes to branch_2 commit 2" >> README.md
git status
git add README.md
git status
git commit -m "branch_2 commit 2"
git status
git push origin branch_2:branch_2
git status

git checkout main
git status

echo "Done setting up this current repository for individual assignment 2.\n"

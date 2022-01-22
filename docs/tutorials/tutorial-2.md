# Tutorial 2

# Forking on GitHub

## Reference

[https://docs.github.com/en/get-started/quickstart/fork-a-repo](https://docs.github.com/en/get-started/quickstart/fork-a-repo)

## Motivation

- Contribute to repositories that you don't have access to
    - Example: Open source repositories
- Create your own version of a repository and implement your requirements
    - Example: In-house version of an open source repository
- Use another repository as a starting point to your new repository
    - Example: Copy and modify an analysis

## Workflow

- Fork
- Clone
- Create a branch
- Create and edit files
- Commit
- Push
- Open a PR
    - Remember to follow the repository guidelines

**Exercise**

- Apply this workflow to [https://github.com/UBC-DSCI/fork-test.git](https://github.com/UBC-DSCI/fork-test.git)

## When your forked repository is not up to date

- Ideally, you want your repository to be as much as up to date as possible before opening a PR
- But some open source projects are very fast paced
- In this case, it’s ok to be a few commits behind
- Worst case scenario, the reviewer will ask you to update your PR

## How to fix

- Reference: [https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)
    - Instructor observation: show how I googled this link

**On Github**

![Untitled](https://docs.github.com/assets/cb-33284/images/help/repository/fetch-upstream-drop-down.png)

**On terminal**

```bash
# I am assuming you have already forked a repository on GitHub, cloned to your
# machine and accessed its folder

# Check the list of remotes and add the original repository as "upstream"
git remote -v
git remote add upstream <ORIGINAL REPO LINK>
git remote -v

# Fetch the branches and their respective commits from the original repository
git fetch upstream

# Switch to "main" and merge the original repository commits to it
git checkout main
git merge upstream/main

# Optional!!!
# You may want to update your PR branch based on the updated main branch
# Be careful with git push -f
git rebase main <PR BRANCH NAME>
git push -f origin <PR BRANCH NAME>
```

**Exercise**

- Repeat the workflow with an open source repository
    - Suggestions: [https://github.com/numpy/numpy](https://github.com/numpy/numpy)

## Notes

- Difference between origin and upstream
    - origin is your fork, upstream is the original repository
    - [https://stackoverflow.com/questions/9257533/what-is-the-difference-between-origin-and-upstream-on-github](https://stackoverflow.com/questions/9257533/what-is-the-difference-between-origin-and-upstream-on-github)
- Difference between fetch and pull
    - In the simplest terms, git pull does a git fetch followed by a git merge
    - [https://stackoverflow.com/questions/292357/what-is-the-difference-between-git-pull-and-git-fetch](https://stackoverflow.com/questions/292357/what-is-the-difference-between-git-pull-and-git-fetch)

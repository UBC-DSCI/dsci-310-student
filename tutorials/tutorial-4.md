# Tutorial 4

`{renv}` documentation: https://rstudio.github.io/renv/index.html

## Part 1: Motivation

Please, do the following:
1. Clone the hard cowsay repository and try to run the script `hello_world.R`: https://github.com/DSCI-310/hard-cowsay
2. Clone the easy cowsay repository and try following the instructions: https://github.com/DSCI-310/easy-cowsay

Notes:
- Notice how `{renv}` made the experience easier for a new user
- `{renv}` has other advantages besides making it easy to install the R dependencies of a project. For instance:
    - Isolate the dependencies of a project from the rest of the system
    - Manage dependencies

## Part 2: Set up `{renv}` (`renv::init()`) (`git init`)

Please, do the following:
1. Run the R command `install.packages("renv")` to install `{renv}`
2. Fork the fair coin analysis repository: https://github.com/DSCI-310/fair-coin-analysis
3. Clone it
4. Run `renv::init()` on the R console
5. Commit all the files created by `{renv}`
6. That's it 🥳

Notes:
- You can check that `{renv}` is set up by restarting the R session and executing the R command `renv::status()`
- You can also run the `scripts/analyze.R` script and see the results in the `results/` folder

## Part 3: Add packages (`renv::snapshot()`) (`git add` and `git commit`)

Please, do the following:
1. Run the R command `install.packages("cowsay")` to install `{cowsay}`
2. Run `renv::snapshot()`
3. Create a script that loads `{cowsay}` and use it to conclude if the coin is fair
4. Run `renv::snapshot()` again
5. Commit the new script and `renv.lock`
6. That's it 🥳

Notes:
- Notice how `renv::snapshot()` did nothing the first time even though we installed `{cowsay}`
- `renv::snapshot()` only changed `renv.lock` when it detected a new package being actively used in a script

## Part 4: Restore to previous state (`renv::restore()`) (`git revert`)

Please, do the following:

Notes:
- You can force `{renv}` delete any currently not used package with `renv::restore(clean = TRUE)`

## Part 5: Go crazy

Notes:
- This is a quick introduction to `{renv}`
- It has more commands and features. To name a few
  - `renv::install()`, `renv::remove()`, `renv::update()`, `renv::upgrade()`, `renv::use()`
  - documentation for docker
  - documentation for continuous integration

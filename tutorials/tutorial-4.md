# Tutorial 4

`{renv}` documentation: https://rstudio.github.io/renv/articles/renv.html

## Part 1: Motivation

Please, do the following:
1. Clone the hard cowsay repository and try to run the script `hello_world.R`: https://github.com/DSCI-310/hard-cowsay
2. Clone the easy cowsay repository and try following the instructions: https://github.com/DSCI-310/easy-cowsay

Notes:
- Notice how `{renv}` made the experience easier for a new user
- `{renv}` has other advanteges besides making it easy to install the R dependencies of a project. For instance:
    - A
    - B
    - C

## Part 2: Set up `{renv}`

Please, do the following:
1. Run the R command `install.packages("renv")` to install `{renv}`
2. Fork the fair coin analysis repository: https://github.com/GiuseppeTT/fair-coin-analysis
3. Clone it
4. Run `renv::init()` on the R console
5. Commit all the files created by `{renv}`
6. That's it 🥳

Notes:
- You can check that `{renv}` is set up by restarting the R session and excecuting the R command `renv::status()`
- You can also run the `scripts/analyze.R` script and see the results in the `results/` folder

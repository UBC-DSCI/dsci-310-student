# Tutorial 4

`{renv}` documentation: https://rstudio.github.io/renv/index.html

## Part 1: Install `renv`

Goal:

Check that you have the `{renv}` package in R to create and use the `renv.lock` file.
This file is used to create a virtual environment in the R programming language.

Steps:

1. Open R console from the command line or RStudio
2. Run the R command `install.packages("renv")` to install `{renv}`
    - You can install the packges in RStudio, but the follow parts will have you run commands in the Terminal.

## Part 2: Motivation

Goal:

Let's see what happens when we try to run a script that uses a package you don't have yet.

> Do not use RStudio to run these steps. Please run them in your terminal.

Steps:

1. Clone the hard cowsay repository and try to run the script `hello_world.R`: https://github.com/DSCI-310/hard-cowsay
2. To run an R script, locate to the repository and run `Rscript hello_world.R` from the command line
3. The script is using a package that is (possibly) not installed on your local environment. What can you do?
    - Hint: you install it (run `R` in the terminal and use `install.packages()` to install the `cowsay` package)

## Part 3a: An existing `{renv}` project

Goal:

Can you imagine if there were _many_ libraries you didn't have installed?
You would have to install them one at a time as the script runs.
That's pretty annoying, and can really slow things down.

> Do not use RStudio to run these steps. Please run them in your terminal.

Steps:

1. Clone the easy cowsay repository: https://github.com/DSCI-310/easy-cowsay
2. Run the `hello_world.R` script in the terminal with `Rscript hello_world.R`
   Your output might look like this:

```shell
$ Rscript hello_world.R 
# Bootstrapping renv 0.15.2 --------------------------------------------------
* Downloading renv 0.15.2 ... OK
* Installing renv 0.15.2 ... Done!
* Successfully installed and loaded renv 0.15.2.
Warning message:
This project is configured to use R version '4.0.5', but '4.2.2' is currently being used. 
Error in library(cowsay) : there is no package called ‘cowsay’
Execution halted
```

3. Note you still have to install packages.
   Because even through you may have just installed `{cowsay}` R recognized that there is an `.Rprofile`
   file that tells it to load the project into a new `{renv}` project

```shell
$ ls -alh
total 16K
drwxr-xr-x 1 dan dan   96 Feb  3 20:31 .
drwxr-xr-x 1 dan dan  298 Feb  3 20:31 ..
drwxr-xr-x 1 dan dan  138 Feb  3 20:31 .git
-rw-r--r-- 1 dan dan   57 Feb  3 20:31 hello_world.R
-rw-r--r-- 1 dan dan 1016 Feb  3 20:31 README.md
drwxr-xr-x 1 dan dan   78 Feb  3 20:31 renv
-rw-r--r-- 1 dan dan 1.3K Feb  3 20:31 renv.lock
-rw-r--r-- 1 dan dan   26 Feb  3 20:31 .Rprofile
```



## Part 3b

Goal:

We need to tell `{renv}` to install all the packages in this environment. Luckily the `renv.lock` file has all that information, we just need to use it to download everything you need.

> Do not use RStudio to run these steps. Please run them in your terminal.

Steps:

0. (Optional) If you open the file, you'll notice that the R version is stored,
   along with all the other packages needed to get `{cowsay}` to work.
   These are "dependencies" of the `{cowsay}` library.
    - If you would like to see the `renv.lock` file you can run `code renv.lock` in the terminal to view it in VScode.
1. While in your `easy-cowsay` folder, open up the R console. You might see something like this:

```
* Project '~/Desktop/easy-cowsay' loaded. [renv 0.15.2]
* The project library is out of sync with the lockfile.
* Use `renv::restore()` to install packages recorded in the lockfile.
Warning message:
This project is configured to use R version '4.0.5', but '4.2.2' is currently being used.
```

2. Confirm that you and R are both in the `easy-cowsay` folder with `getwd()`.
    - If you're not, the best way is to quit with `q()`, do not save your state, and `cd` to the `easy-cowsay` folder

```
> getwd()
[1] "/home/dan/Desktop/easy-cowsay"
```

3. Initialize + install everything in the `renv.lock` file. By running the `init()` function from the `{renv}` library.
   1. You can `library(renv)` and then run `init()` OR
   2. you can run `renv::init()`, this let's you run `init()` without calling `library()`, the `::` essentially runs a function directly from the specifiec package to the left of the `::`.

4. Since the `renv.lock` file already exists, we just want to restore from the lockfile.

```
> renv::init()
This project already has a lockfile. What would you like to do? 

1: Restore the project from the lockfile.
2: Discard the lockfile and re-initialize the project.
3: Activate the project without snapshotting or installing any packages.
4: Abort project initialization.

Selection: 1
```

5. `renv` will install all the packages + dependencies as specified by `renv.lock`

```
Selection: 1
* Restoring project ... 
The following package(s) will be updated:

# CRAN ===============================
- cowsay     [* -> 0.8.0]
- crayon     [* -> 1.4.2]
- fortunes   [* -> 1.5-4]
- rmsfact    [* -> 0.0.3]

* Querying repositories for available source packages ... Done!
Retrieving 'https://cloud.r-project.org/src/contrib/cowsay_0.8.0.tar.gz' ...
        OK [downloaded 564.5 Kb in 0.3 secs]
Retrieving 'https://cloud.r-project.org/src/contrib/Archive/crayon/crayon_1.4.2.tar.gz' ...
        OK [downloaded 38.8 Kb in 0.1 secs]
Retrieving 'https://cloud.r-project.org/src/contrib/fortunes_1.5-4.tar.gz' ...
        OK [downloaded 188.4 Kb in 0.3 secs]
Retrieving 'https://cloud.r-project.org/src/contrib/rmsfact_0.0.3.tar.gz' ...
        OK [downloaded 10.5 Kb in 0.2 secs]
Installing crayon [1.4.2] ...
        OK [built from source]
Moving crayon [1.4.2] into the cache ...
        OK [moved to cache in 0.2 milliseconds]
Installing fortunes [1.5-4] ...
        OK [built from source]
Moving fortunes [1.5-4] into the cache ...
        OK [moved to cache in 0.2 milliseconds]
Installing rmsfact [0.0.3] ...
        OK [built from source]
Moving rmsfact [0.0.3] into the cache ...
        OK [moved to cache in 0.15 milliseconds]
Installing cowsay [0.8.0] ...
        OK [built from source]
Moving cowsay [0.8.0] into the cache ...
        OK [moved to cache in 0.16 milliseconds]
* Project '~/Desktop/easy-cowsay' loaded. [renv 0.15.2]
* renv activated -- please restart the R session.
Warning message:
This project is configured to use R version '4.0.5', but '4.2.2' is currently being used. 
```

6. Take a look at the CRAN page for `{cowsay}` (you can do this by googling "cowsay CRAN")
    - https://cran.r-project.org/web/packages/cowsay/index.html
7. Compare the version installed by `renv::init()` / `renv::restore()` and the latest version on CRAN.

Notes:

- Notice how `{renv}` made the experience easier for a new user
- `{renv}` has other advantages besides making it easy to install the R dependencies of a project. For instance:
    - Isolate the dependencies of a project from the rest of the system
    - Manage dependencies
    - The packages installed do not have to be the latest one on CRAN.

## Part 4: Set up `{renv}` (`renv::init()`) in RStudio

> Do the rest of tutorial in RStudio. This is because we are now using RStudio projects.

Please, do the following:
1. Clone the fair coin analysis repository: https://github.com/DSCI-310/fair-coin-analysis
2. Go to the folder and open `fair-coin-analysis.Rproj`. RStudio will setup the working directory for you.
3. Run `renv::init()` on the R console
4. Run the `analyze.R` by running `Rscript scripts/analyze.R` and see the results in the `results/` folder
5. That's it 🥳

Notes:
- You can check that `{renv}` is set up by restarting the R session and executing the R command `renv::status()`

## Part 5: Add packages (`renv::snapshot()`)

Please, do the following:
1. Run the R command `renv::install("cowsay")` to install `{cowsay}` 
2. Run `renv::snapshot()`
3. Create a script that loads `{cowsay}` and use it to conclude if the coin is fair
4. Run `renv::snapshot()` again
6. That's it 🥳

Notes:

- In an `renv` project, `renv::install()` does the job of `install.packages()`

- Notice how `renv::snapshot()` did nothing the first time even though we installed `{cowsay}`
- `renv::snapshot()` only changed `renv.lock` when it detected a new package being actively used in a script

## Part 6: Restore to previous state (`renv::restore()`)

Please, do the following:
1. Run the R command `renv::install("sckott/cowsay")` to install the dev version of `{cowsay}`
2. Run the R command `renv::status()` to check the current state of the environment
3. Run the R command `renv::restore()` to restore environment from the `renv.lock` file
4. That's it 🥳

Notes:
- You can force `{renv}` delete all currently not used packagse with `renv::restore(clean = TRUE)`

## Part 6: Go crazy!

Notes:
- This is a quick introduction to `{renv}`
- It has more commands and features. To name a few:
    - `renv::remove()`
    - `renv::update()`
    - `renv::upgrade()`
    - `renv::use()`
    - documentation for docker
    - documentation for continuous integration

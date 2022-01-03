#!/usr/bin/env bash
# Checks that the correct version of all system programs and R & Python packages
# which are needed for DSCI 310 are currently installed

# 0. Help message and OS info
echo ''
echo "# DSCI 310 setup check 1.0" | tee check_setup.log
echo '' | tee -a check_setup.log
echo 'If a program or package is marked as MISSING,'
echo 'this means that you are missing the required version of that program or package.'
echo 'Either it is not installed at all or the wrong version is installed.'
echo 'The required version is indicated with a number and an asterisk (*),'
echo 'e.g. 4.* means that all versions starting with 4 are accepted (4.0.1, 4.2.5, etc).'
echo ''
echo 'You can run the following commands to find out which version'
echo 'of a program or package is installed (if any):'
echo '```'
echo 'name_of_program --version  # For system programs'
echo 'conda list  # For Python packages'
echo 'R -q -e "installed.packages()[,c('Package', 'Version')]"  # For R packages'
echo '```'
echo ''
echo 'Checking program and package versions...'
echo '## Operating system' >> check_setup.log
if [[ "$(uname)" == 'Linux' ]]; then
    # sed is for alignment purposes
    sys_info=$(hostnamectl)
    os_version=$(grep "Operating" <<< $sys_info | sed 's/^[[:blank:]]*//')
    echo $os_version >> check_setup.log
    grep "Architecture" <<< $sys_info | sed 's/^[[:blank:]]*//;s/:/:    /' >> check_setup.log
    grep "Kernel" <<< $sys_info | sed 's/^[[:blank:]]*//;s/:/:          /' >> check_setup.log
    file_browser="xdg-open"
    if ! $(grep -iq "20.04" <<< $os_version); then
        echo '' >> check_setup.log
        echo "MISSING You need Ubuntu 20.04." >> check_setup.log
    fi
elif [[ "$(uname)" == 'Darwin' ]]; then
    sw_vers >> check_setup.log
    file_browser="open"
    if ! $(sw_vers | grep -q -E "11.[4-6]|12.[0-9]"); then
        echo '' >> check_setup.log
        echo "MISSING Big Sur or above (version 11.4.x and above)" >> check_setup.log
    fi
elif [[ "$OSTYPE" == 'msys' ]]; then
    # wmic use some non-ASCII characters that we need grep (or sort or similar) to convert,
    # otherwise the logfile looks weird. There is also an additional newline at the end.
    os_edition=$(wmic os get caption | grep Micro | sed 's/\n//g')
    echo $os_edition >> check_setup.log
    wmic os get osarchitecture | grep bit | sed 's/\n//g' >> check_setup.log
    os_version=$(wmic os get version | grep 10 | sed 's/\n//g')
    echo $os_version >> check_setup.log
    file_browser="explorer"

    if $(grep -iq Home <<< $os_edition); then
        echo '' >> check_setup.log
        echo "MISSING Windows Home is not sufficient. Please upgrade to the free Education edition as per the setup instructions." >> check_setup.log
    fi
    if ! $(grep -iq "1904[1|2|3|4]" <<< $os_version); then
        echo '' >> check_setup.log
        echo "MISSING You need at least Windows build 10.0.19041. Please run Windows update." >> check_setup.log
    fi
else
    echo "Operating system verison could not be detected." >> check_setup.log
fi
echo '' >> check_setup.log

# 1. System programs
# Tries to run system programs and if successful greps their version string
# Currently marks both uninstalled and wrong verion number as MISSING
echo "## System programs" >> check_setup.log

# There is an esoteric case for .app programs on macOS where `--version` does not work.
# Also, not all programs are added to path,
# so easier to test the location of the executable than having students add it to PATH.
if [[ "$(uname)" == 'Darwin' ]]; then
    # rstudio is installed as an .app
    if ! $(grep -iq "= \"2021\.09.*" <<< "$(mdls -name kMDItemVersion /Applications/RStudio.app)"); then
        echo "MISSING   rstudio 2021.09.*" >> check_setup.log
    else
        # This is what is needed instead of --version
        installed_version_tmp=$(grep -io "= \"2021\.09.*" <<< "$(mdls -name kMDItemVersion /Applications/RStudio.app)")
        # Tidy strangely formatted version number
        installed_version=$(sed "s/= //;s/\"//g" <<< "$installed_version_tmp")
        echo "OK        "rstudio $installed_version >> check_setup.log
    fi

    # Remove rstudio and psql from the programs to be tested using the normal --version test
    sys_progs=(R=4.* python=3.* conda=4.* bash=3.* git=2.* make=3.* latex=3.* tlmgr=5.* docker=20.* code=1.*)
# psql and Rstudio are not on PATH in windows
elif [[ "$OSTYPE" == 'msys' ]]; then
    if ! [ -x "$(command -v '/c/Program Files/PostgreSQL/13/bin/psql')" ]; then
        echo "MISSING   psql 13.*" >> check_setup.log
    else
        echo "OK        "$('/c/Program Files/PostgreSQL/13/bin/psql' --version) >> check_setup.log
    fi
    # Rstudio on windows does not accept the --version flag when run interactively
    # so this section can only be troubleshot from the script
    if ! $(grep -iq "2021\.09.*" <<< "$('/c//Program Files/RStudio/bin/rstudio' --version)"); then
        echo "MISSING   rstudio 2021.09*" >> check_setup.log
    else
        echo "OK        rstudio "$('/c//Program Files/RStudio/bin/rstudio' --version) >> check_setup.log
    fi
    # tlmgr needs .bat appended on windows and it cannot be tested as an exectuable with `-x`
    if ! [ "$(command -v tlmgr.bat)" ]; then
        echo "MISSING   tlmgr 5.*" >> check_setup.log
    else
        echo "OK        "$(tlmgr.bat --version | head -1) >> check_setup.log
    fi
    # Remove rstudio from the programs to be tested using the normal --version test
    sys_progs=(R=4.* python=3.* conda=4.* bash=4.* git=2.* make=4.* latex=3.* docker=20.* code=1.*)
else
    # For Linux everything is sane and consistent so all packages can be tested the same way
    sys_progs=(psql=13.* rstudio=2021\.09.* R=4.* python=3.* conda=4.* bash=5.* \
        git=2.* make=4.* latex=3.* tlmgr=5.* docker=20.* code=1.*)
    # Note that the single equal sign syntax in used for `sys_progs` is what we have in the install
    # instruction for conda, so I am using it for Python packagees so that we
    # can just paste in the same syntax as for the conda installations
    # instructions. Here, I use the same single `=` for the system packages
    # (and later for the R packages) for consistency.
fi

for sys_prog in ${sys_progs[@]}; do
    sys_prog_no_version=$(sed "s/=.*//" <<< "$sys_prog")
    regex_version=$(sed "s/.*=//" <<< "$sys_prog")
    # Check if the command exists and is is executable
    if ! [ -x "$(command -v $sys_prog_no_version)" ]; then
        # If the executable does not exist
        echo "MISSING   $sys_prog" >> check_setup.log
    else
        # Check if the version regex string matches the installed version
        # Use `head` because `R --version` prints an essay...
        # Unfortunately (and inexplicably) R on windows and Python2 on macOS
        # prints version info to stderr instead of stdout
        # Therefore I use the `&>` redirect of both streams,
        # I don't like chopping of stderr with `head` like this,
        # but we should be able to tell if something is wrong from the first line
        # and troubleshoot from there
        if ! $(grep -iq "$regex_version" <<< "$($sys_prog_no_version --version &> >(head -1))"); then
            # If the version is wrong
            echo "MISSING   $sys_prog" >> check_setup.log
        else
            # Since programs like rstudio and vscode don't print the program name with `--version`,
            # we need one extra step before logging
            installed_version=$(grep -io "$regex_version" <<< "$($sys_prog_no_version --version &> >(head -1))")
            echo "OK        "$sys_prog_no_version $installed_version >> check_setup.log
        fi
    fi
done

# 2. Python packages
# Greps the `conda list` output for correct version numbers
# Currently marks both uninstalled and wrong verion number as MISSING
echo "" >> check_setup.log
echo "## Python packages" >> check_setup.log
if ! [ -x "$(command -v conda)" ]; then  # Check that conda exists as an executable program
    echo "Please install 'conda' to check Python package versions." >> check_setup.log
    echo "If 'conda' is installed already, make sure to run 'conda init'" >> check_setup.log
    echo "if this was not chosen during the installation." >> check_setup.log
    echo "In order to do this after the installation process," >> check_setup.log
    echo "first run 'source <path to conda>/bin/activate' and then run 'conda init'." >> check_setup.log
else
    py_pkgs=(pandas=1 pyppeteer=0 nbconvert=6 jupyterlab=3 jupyterlab-git=0 jupytext=1 jupyterlab-spellchecker=0)
    # installed_py_pkgs=$(pip freeze)
    installed_py_pkgs=$(conda list | tail -n +4 | tr -s " " "=" | cut -d "=" -f -2)
    for py_pkg in ${py_pkgs[@]}; do
        # py_pkg=$(sed "s/=/==/" <<< "$py_pkg")
        if ! $(grep -iq "$py_pkg" <<< $installed_py_pkgs); then
            echo "MISSING   ${py_pkg}.*" >> check_setup.log
        else
            # Match the package name up until the first whitespace to get regexed versions
            # without getting all following packages contained in the string of all pacakges
            echo "OK        $(grep -io "${py_pkg}\S*" <<< $installed_py_pkgs)" >> check_setup.log
        fi
    done
fi

# jupyterlab PDF and HTML generation
if ! [ -x "$(command -v jupyter)" ]; then  # Check that jupyter exists as an executable program
    echo "Please install 'jupyterlab' before testing PDF generation." >> check_setup.log
else
    # Create an empty json-compatible notebook file for testing
    echo '{
     "cells": [
      {
       "cell_type": "code",
       "execution_count": null,
       "metadata": {},
       "outputs": [],
       "source": []
      }
     ],
     "metadata": {
      "kernelspec": {
       "display_name": "",
       "name": ""
      },
      "language_info": {
       "name": ""
      }
     },
     "nbformat": 4,
     "nbformat_minor": 4
    }' > mds-nbconvert-test.ipynb
    # Test PDF
    if ! jupyter nbconvert mds-nbconvert-test.ipynb --to pdf --log-level 'ERROR' &> jupyter-pdf-error.log; then
        echo 'MISSING   jupyterlab PDF-generation failed. Check that latex and jupyterlab are marked OK above, then read the detailed error message in the log file.' >> check_setup.log
    else
        echo 'OK        jupyterlab PDF-generation was successful.' >> check_setup.log
    fi
    # Test WebPDF
    # I don't want to automate any of the installation steps since it can be harder to troubleshoot then,
    # so we just output and error message telling students is the most probable cause of the failure.
    if ! [ -x "$(command -v pyppeteer-install)" ]; then  # Check that pyppeteer-install exists as an executable program
        echo 'MISSING   jupyterlab WebPDF-generation failed. It seems like you did not run `pip install "nbconvert[webpdf]"` to install pyppeteer.' >> check_setup.log
    else
        # If the student didn't run `pypeteer-install`
        # then that command will try to download chromium,
        # which should always take more than 1s
        # so `timeout` will interupt it with exit code 1.
        # If chromium is already installed,
        # this command just returns an info message which should not take more than 1s.
        # ----
        # Unfortunately, apple has decided not to use gnu-coreutils,
        # so we need to use less reliable solution on macOS;
        # there might be corner cases where this breaks
        if [[ "$(uname)" == 'Darwin' ]]; then
            # The surrounding $() here is just to supress the alarm clock output
            # as redirection does not work.
            $(perl -e 'alarm shift; exec pyppeteer-install' 1)
        else
            # Using the reliable `timeout` tool on Linux and Windows
            timeout 1s pyppeteer-install &> /dev/null
        fi
        # `$?` stores the exit code of the last program that as executed
        if ! [ $? ]; then
            echo 'MISSING   jupyterlab WebPDF-generation failed. It seems like you have not run `pyppeteer-install` to download chromium for jupyterlab WebPDF export.' >> check_setup.log
        elif ! jupyter nbconvert mds-nbconvert-test.ipynb --to webpdf --log-level 'ERROR' &> jupyter-webpdf-error.log; then
            echo 'MISSING   jupyterlab WebPDF-generation failed. Check that jupyterlab, nbconvert, and pyppeteer are marked OK above, then read the detailed error message in the log file.' >> check_setup.log
        else
            echo 'OK        jupyterlab WebPDF-generation was successful.' >> check_setup.log
        fi
    fi
    # Test HTML
    if ! jupyter nbconvert mds-nbconvert-test.ipynb --to html --log-level 'ERROR' &> jupyter-html-error.log; then
        echo 'MISSING   jupyterlab HTML-generation failed. Check that jupyterlab and nbconvert are marked OK above, then read the detailed error message in the log file.' >> check_setup.log
    else
        echo 'OK        jupyterlab HTML-generation was successful.' >> check_setup.log
    fi
    # -f makes sure `rm` succeeds even when the file does not exists
    rm -f mds-nbconvert-test.ipynb mds-nbconvert-test.pdf mds-nbconvert-test.html
fi

# 3. R packages
# Format R package output similar to above for python and grep for correct version numbers
# Currently marks both uninstalled and wrong verion number as MISSING
echo "" >> check_setup.log
echo "## R packages" >> check_setup.log
if ! [ -x "$(command -v R)" ]; then  # Check that R exists as an executable program
    echo "Please install 'R' to check R package versions." >> check_setup.log
else
    r_pkgs=(cowplot=1 GGally=2 kknn=1 scales=1 tidyverse=1 tidymodels=0)
    installed_r_pkgs=$(R -q -e "print(format(as.data.frame(installed.packages()[,c('Package', 'Version')]), justify='left'), row.names=FALSE)" | grep -v "^>" | tail -n +2 | sed 's/^ //;s/ *$//' | tr -s ' ' '=')
    for r_pkg in ${r_pkgs[@]}; do
        if ! $(grep -iq "$r_pkg" <<< $installed_r_pkgs); then
            echo "MISSING   $r_pkg.*" >> check_setup.log
        else
            # Match the package name up until the first whitespace to get regexed versions
            # without getting all following packages contained in the string of all pacakges
            echo "OK        $(grep -io "${r_pkg}\S*" <<< $installed_r_pkgs)" >> check_setup.log
        fi
    done
fi

# rmarkdown PDF and HTML generation
if ! [ -x "$(command -v R)" ]; then  # Check that R exists as an executable program
    echo "Please install 'R' before testing PDF and HTML generation." >> check_setup.log
else
    # Create an empty Rmd-file for testing
    touch mds-knit-pdf-test.Rmd
    if ! Rscript -e "rmarkdown::render('mds-knit-pdf-test.Rmd', output_format = 'pdf_document')" &> /dev/null; then
        echo "MISSING   rmarkdown PDF-generation failed. Check that latex and rmarkdown are marked OK above." >> check_setup.log
    else
        echo 'OK        rmarkdown PDF-generation was successful.' >> check_setup.log
    fi
    if ! Rscript -e "rmarkdown::render('mds-knit-pdf-test.Rmd', output_format = 'html_document')" &> /dev/null; then
        echo "MISSING   rmarkdown HTML-generation failed. Check that rmarkdown is marked OK above." >> check_setup.log
    else
        echo 'OK        rmarkdown HTML-generation was successful.' >> check_setup.log
    fi
    # -f makes sure `rm` succeeds even when the file does not exists
    rm -f mds-knit-pdf-test.Rmd mds-knit-pdf-test.html mds-knit-pdf-test.pdf
fi

# 4. Ouput the saved file to stdout
# I am intentionally showing the entire output in the end,
# instead of progressively with `tee` throughout
# so that students have time to read the help message in the beginning.
tail -n +2 check_setup.log  # `tail` to skip rows already echoed to stdout

# Output details about PDF and HTML creation errors
# This is outputted after all the package OK/MISSING info
# to separate the detailed error message from the overview of which packages installed correctly.
if [ -s jupyter-pdf-error.log ]; then
    echo '' >> check_setup.log
    echo '======== You had the following errors during Jupyter PDF generation ========' >> check_setup.log
    cat jupyter-pdf-error.log >> check_setup.log
    echo '======== End of Jupyter PDF error ========' >> check_setup.log
fi
if [ -s jupyter-webpdf-error.log ]; then
    echo '' >> check_setup.log
    echo '======== You had the following errors during Jupyter WebPDF generation ========' >> check_setup.log
    cat jupyter-webpdf-error.log >> check_setup.log
    echo '======== End of Jupyter WebPDF error ========' >> check_setup.log
fi
if [ -s jupyter-html-error.log ]; then
    echo '' >> check_setup.log
    echo 'You had the following errors during Jupyter HTML generation:' >> check_setup.log
    cat jupyter-html-error.log >> check_setup.log
    echo '======== End of Jupyter HTML error ========' >> check_setup.log
fi
# -f makes sure `rm` succeeds even when the file does not exists
rm -f jupyter-html-error.log jupyter-webpdf-error.log jupyter-pdf-error.log

# Student don't need to see this in stdout, but useful to have in the log-file
# env
echo '' >> check_setup.log
echo "## Environmental variables" >> check_setup.log
env >> check_setup.log

# .bash_profile
echo '' >> check_setup.log
echo "## Content of .bash_profile" >> check_setup.log
if ! [ -f ~/.bash_profile ]; then
    echo "~/.bash_profile not found" >> check_setup.log
else
    cat ~/.bash_profile >> check_setup.log
fi

# .bashrc
echo '' >> check_setup.log
echo "## Content of .bashrc" >> check_setup.log
if ! [ -f ~/.bashrc ]; then
    echo "~/.bashrc not found" >> check_setup.log
else
    cat ~/.bashrc >> check_setup.log
fi

echo
echo "The above output has been saved to the file $(pwd)/check_setup.log"
echo "together with system configuration details and any detailed error messages about PDF and HTML generation."
echo "You can open this folder in your file browser by typing \`${file_browser} .\` (without the surrounding backticks)."

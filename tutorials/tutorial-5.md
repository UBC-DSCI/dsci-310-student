# Tutorial 5

## Part 1

### References

- rocker: [https://www.rocker-project.org/](https://www.rocker-project.org/)
- rocker mount volume: [https://www.rocker-project.org/use/shared_volumes/](https://www.rocker-project.org/use/shared_volumes/)
- rocker install R package: [https://www.rocker-project.org/use/extending/](https://www.rocker-project.org/use/extending/)
- renv integrate docker: [https://rstudio.github.io/renv/articles/docker.html](https://rstudio.github.io/renv/articles/docker.html)
- DSCI jupyterlab image: [https://hub.docker.com/r/ubcdsci/jupyterlab](https://hub.docker.com/r/ubcdsci/jupyterlab)

### Hands-on

Repo: https://github.com/DSCI-310/fair-coin-analysis

Try 1:
- Run: `docker run -e PASSWORD=yourpassword --rm -p 8787:8787 rocker/rstudio`
    - `localhost:8787`

Try 2:
- Run with volume: `docker run -e PASSWORD=yourpassword -p 8787:8787 -v ${PWD}:/home/rstudio rocker/rstudio`
- `install.packages("binom")`

Try 3:
- Add docker file
- Build: `docker build -t fair-coin-analysis .`
- Run with volume: `docker run -e PASSWORD=yourpassword -p 8787:8787 -v ${PWD}:/home/rstudio fair-coin-analysis`

Try 4:
- Change docker file
    - `RUN Rscript -e "install.packages('binom')"`
- Build: `docker build -t fair-coin-analysis .`
- Run with volume: `docker run -e PASSWORD=yourpassword -p 8787:8787 -v ${PWD}:/home/rstudio fair-coin-analysis`

Try 5:
- Change docker file
    - `RUN install2.r --error --skipinstalled --ncpus -1 \
    binom`
- Build: `docker build -t fair-coin-analysis .`
- Run with volume: `docker run -e PASSWORD=yourpassword -p 8787:8787 -v ${PWD}:/home/rstudio fair-coin-analysis`

Try 6:
- Change docker file
    - `ENV RENV_VERSION 0.15.2-2
    RUN R -e "install.packages('remotes', repos = c(CRAN = '[https://cloud.r-project.org](https://cloud.r-project.org/)'))"
    RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"`
    - `COPY renv.lock renv.lock
    RUN R -e "renv::restore()"`
- Build: `docker build -t fair-coin-analysis .`
- Run with volume: `docker run -e PASSWORD=yourpassword -p 8787:8787 -v ${PWD}:/home/rstudio fair-coin-analysis`

Try 7:
- Change docker file
    - `FROM ubcdsci/jupyterlab`
- Build: `docker build -t fair-coin-analysis .`
- Run with volume: `docker run --rm --user root -v $(pwd):/opt/notebooks -p 8888:8888 fair-coin-analysis`

Bonus:
- Log in to docker hub: `docker login`
- Create a repo for your image
- Properly tag your image: `docker tag fair-coin-analysis <dockerhub username>/fair-coin-analysis`
- Push: `docker push <dockerhub username>/fair-coin-analysis`

## Part 2

Work in groups and set up a Dockerfile for your group project.

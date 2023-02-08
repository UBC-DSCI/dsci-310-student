# Tutorial 5

## Part 1

> **Note**
> 
> If you haven't already, clone the repo: https://github.com/DSCI-310/fair-coin-analysis
> 
> Then, navigate into the repo folder.


### Step 1: Run the `rocker/rstudio` Container
To run the Docker container, open Terminal/Git bash and run:

```
docker run -e PASSWORD=apassword --rm -p 8787:8787 rocker/rstudio:4.1.3
```
 
Then go to [`localhost:8787`](localhost:8787)

#### Notes:
  - This is the same process [as seen in lecture](https://ubc-dsci.github.io/reproducible-and-trustworthy-workflows-for-data-science/materials/lectures/05-containerization.html#mapping-ports-to-containers-with-web-apps) where we map ports to containers so that we can use RStudio's GUI.
  - Notice that you do not have any access to the files on your computer.

---

### Step 2: Run the Container with a Volume

#### Goal
Mount a volume to the container, so that you're able to access the files on your computer.

#### Step 2a
In Terminal/Git bash, run: 

```
docker run -e PASSWORD=apassword -p 8787:8787 -v ${PWD}:/home/rstudio rocker/rstudio
```

Then, go to `localhost:8787`

#### Step 2b
Now, in the RStudio console, install the `binom` package.

> **Warning**
> 
> This is done in the RStudio that you just opened in `localhost:8787`. Not in the RStudio installed on your machine.


```
install.packages("binom")
```

#### Notes
- In the lecture notes, we suggest `-v /$(pwd):/home/rstudio` for volume mounting, as this works more consistently across operating systems, however see the note about Windows below.
- If the volume mounting doesn't work with the above on Windows, try: `-v /$(pwd)://home//rstudio`

---

### Step 3: Add a `Dockerfile`

Now that we've confirmed that `install:packages('binom')` works, we need to add it to our `Dockerfile`. 

#### Step 3a
Create a `Dockerfile` in the `fair-coin-analysis` directory. 

> **Note**
>
> The `Dockerfile` should have:
> - specifying the base image: `rocker/rstudio:4.1.3`
> - installing the `binom` package


#### Step 3b
Now, build the `Dockerfile` by running `docker build` in Terminal/Git bash:
 
```
docker build -t fair-coin-analysis .
```

#### Step 3c
Finally, run the `fair-coin-analysis` container with a mounted volume: 

```
docker run -e PASSWORD=apassword -p 8787:8787 -v ${PWD}:/home/rstudio fair-coin-analysis
```

---

### Step 4: Modify the `Dockerfile`

#### Step 4a
Change the `Dockerfile`, so it has the following lines:

```
ENV RENV_VERSION 0.15.2-2
RUN R -e "install.packages('remotes', repos = c(CRAN = '[https://cloud.r-project.org](https://cloud.r-project.org/)'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
COPY renv.lock renv.lock
RUN R -e "renv::restore()"
```

#### Step 4b
Build the container.

```
docker build -t fair-coin-analysis .
```

#### Step 4c
Run the container with a mounted volume.

```
docker run -e PASSWORD=yourpassword -p 8787:8787 -v ${PWD}:/home/rstudio fair-coin-analysis
```

### Step 5: Modify the `Dockerfile` Base Image

#### Step 5a
Change the base image to `ubcdsci/jupyterlab`

#### Step 5b
Build the container.

 ```
 docker build -t fair-coin-analysis .
 ```

#### Step 5c
Run with a mounted volume.
```
docker run --rm --user root -v $(pwd):/opt/notebooks -p 8888:8888 fair-coin-analysis
```

### Bonus:
- Log in to docker hub: `docker login`
- Create a repo for your image
- Properly tag your image: `docker tag fair-coin-analysis <dockerhub username>/fair-coin-analysis`
- Push: `docker push <dockerhub username>/fair-coin-analysis`

---

## Part 2

Work in groups and set up a `Dockerfile` for your group project.


---
## References

- rocker: [https://www.rocker-project.org/](https://www.rocker-project.org/)
- rocker mount volume: [https://www.rocker-project.org/use/shared_volumes/](https://www.rocker-project.org/use/shared_volumes/)
- rocker install R package: [https://www.rocker-project.org/use/extending/](https://www.rocker-project.org/use/extending/)
- renv integrate docker: [https://rstudio.github.io/renv/articles/docker.html](https://rstudio.github.io/renv/articles/docker.html)
- DSCI jupyterlab image: [https://hub.docker.com/r/ubcdsci/jupyterlab](https://hub.docker.com/r/ubcdsci/jupyterlab)

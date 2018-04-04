#!/usr/bin/env R
library(EightyR)
load_toolbox()
load_pkg("plumber")
r <- plumb("plumber.R")
r$run(host = "0.0.0.0", port=8000)

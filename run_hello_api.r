#!/usr/bin/env R

# run_hello_api.r

r <- plumb("hello_api.R")  # Where 'plumber.R' is the location of the file shown above
r$run(port=8000)

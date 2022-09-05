# ---
# title: Downloading files
# status: rc
# ---

# In this module, we will see how *Julia* allows downloading files from the
# internet, and how we can decide where to store them. This is a common task
# when getting external data, and will be the basis of a number of advanced
# training modules in the final section of this material.

# <!--more-->

# The {{Downloads}} package is part of the standard library, and is one of the
# simplest package we can think of: it only exports a single function, called
# `download`, whose purpose is to download things. Would that programming were
# always that easy.

import Downloads

# By default, `download` will store the download in a temporary file, which as
# we saw before, will be stored in `tempdir()`. To illustrate, we can download
# the "seeds" dataset (we will use it in a later advanced example):

seeds_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/00236/seeds_dataset.txt"
raw_seeds_file = Downloads.download(seeds_url)

# !!!WARNING In versions of *Julia* before 1.6, the {{Base}} package also
# exported a `download` function, but it is slowly being phased out. The version
# provided by {{Downloads}} has a lot more flexibility, and should be used.

# Note that calling `download` has returned a path to a temporary file. We can
# also specify where things should be stored, using a second argument to
# `download`:

raw_seeds_file = Downloads.download(seeds_url, "seeds.txt")

# We can check that the file exists:

isfile(raw_seeds_file)

# One advantage of the `download` function is that it can be tweaked to display
# a progress indicator, using a *callback* function.

# !!!INFO A Callback function is any function that is executed on the side of
# the important process, in order to update the user on the progress, or to
# check that the conditions of executions are still met.

# The progress callback we will use here is simply displaying the (rounded)
# percentage of the file that has been downloaded. Because the file is very
# small, it will jump to 100% almost immediately, but this would be more
# informative with longer downloads, and a package like {{ProgressMeter}} to
# display an actual progressbar.

function progress_callback(total::Integer, now::Integer)
    if total > 0
        @info "Progress: $(rpad(Int(round(now/total * 100; digits=0)), 4))%"
    end
end

# We can now add this callback to our `download` function:

raw_seeds_file = Downloads.download(seeds_url; progress = progress_callback)

# The `download` function has a few additional options we can use, like setting
# a timeout for long downloads, or using a different downloader like `curl` or
# `wget`. In most cases, these options are not required, and getting a single
# file from a remote location is very straightforward.
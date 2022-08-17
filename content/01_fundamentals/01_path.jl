# ---
# title: The Path
# weight: 1
# ---

# One of the main obstacle to reproductible projects is issues with describing
# where files are. In this module, we will talk about the path, and how to refer
# to locations in a way that will work on any computer.

# The first question we have to answer is, where are we? The answer to this
# question is `pwd`, or *print working directory*. This is telling us where
# *Julia* is actually executing things. In our case, the script for this lesson
# is running in:

pwd()

# The working directory is a very important concept: we can look for things
# *within* it, but we cannot look for things *outside* of it.

# {{< callout information >}} This is not quite entirely true. In some very
# specific cases, we may not want to store a few Gb of data in our working
# directory, and we will refer to those using their absolute path; the best
# practice in this case is probably to setup an environment variable to point to
# the data. {{< /callout >}}

# Why is that? The simple answer is that when you distribute your project, you
# will not distribute the rest of your machine. When working on a laptop (at
# home), a desktop (in the lab), and a cluster (for larger simulations), the
# only certainty is that the working directory is the same; it is unlikely to be
# in the same place, or to have folders outside of it organized in the same way.

# For this reason, the *folder* containing our material is going to be our main
# unit of organization.

# *Julia* has an interesting macro to refer to *the place where the file being
# run is located*:

@__DIR__

# Note that this is an *absolute* path - it starts with a `/`, which is the root
# of your filesystem. But the absolute path is not hard-coded! Working on a
# different system, you would see a different path leading up to your
# `@__DIR__`.

# *Julia* can also print the actual name of the file:

@__FILE__

# Another important concept is the home directory, which is where the operating
# system will put your user files:

homedir()

# Paths are made of different parts, so we can splith `@__FILE__` into its
# components:

splitpath(@__FILE__)

# This is quite nice, because it turned our path into an array of strings.
# Notice that it's making a difference between `/` meaning the root, and `/`
# meaning the filesystem separator.

# Can we create a path in a safe way? Absolutely! Let us create a `data` folder:

data_path = joinpath(pwd(), "data")

# Now, this folder does not exist. It is a string of text describing where it
# is. Can we create it? Yes! But first, let's try a few functions:

isfile(@__DIR__)

#-

isdir(@__DIR__)

#- 

ispath(@__DIR__)

# These three functions are very useful when working on path issues. `isfile`
# will take a string, and let you know if there is a *file* at this location.
# `isdir` will do the same for a directory (folder; we will stick to *directory*
# as it is the more correct term). `ispath` will do the same for *either* a
# folder or a file.

# In our case, we want `data_path` to be a directory, so we will first check
# that it does not exists:

isdir(data_path)

# If it does not exist, we will create it:

if ~isdir(data_path)
    mkdir(data_path)
end

# This line (we will go into the details of `if`, and booleans more broadly, in
# the next few modules) will create the directory if it does not exist. We can
# now read the content of our working directory:

readdir(pwd())

# There seems to be a `data` directory. Note that `readdir` has a number of
# options, and that *Julia* offers additional ways to walk through a series of
# nested directories if neede.

# To finish up, let's remove this directory. We will use `isdir` again because
# we do not want to remove a directory that doesn't exist. It is worth looking
# at the documentation for `rm`, as it has a number of important options and
# keyword arguments.

if isdir(data_path)
    rm(data_path)
end

readdir(pwd())

# As a final bit of information, *Julia* can create temporary files, *i.e.*
# files that will not be stored in the working directory, and will not persist
# after you restart your computer. Your temporary files are always stored in the
# `tempdir` of your computer:

tempdir()

# You can generate a temporary path with:

tempname()

# Note that this string describes just this: a path. You can turn it into a
# file, or a directory. Working with temporary files is very useful when you,
# for example, need to download data in bulk, but do not want to save the raw
# download.
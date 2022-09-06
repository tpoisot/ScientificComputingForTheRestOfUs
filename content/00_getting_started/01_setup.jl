# ---
# title: Preparing a project
# status: release
# ---

# In this module, before we write any code, we will start thinking about what a
# project is, how we can set one up on our computer, and why this might help
# defeat coder's block. 

# <!--more-->

# If your working environment looks anything like mine, the first thing you may
# see on a new project will look like this:

# ~~~
# [tpoisot@fedora ~]$ julia
#                _
#    _       _ _(_)_     |  Documentation: https://docs.julialang.org
#   (_)     | (_) (_)    |
#    _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
#   | | | | | | |/ _` |  |
#   | | |_| | | | (_| |  |  Version 1.8.0 (2022-08-17)
#  _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
# |__/                   |
# 
# julia> 
# ~~~

# This is highly intimidating. The cursor blinks expectantly, and you might not
# have a single clue what to type. Good. Because before we do anything, we need
# to think about project organisation.

# Facing an empty text editor or a blinking REPL (it stands for Read/Execute/Print
# Loop, and this the place where you type things) prompt at the beginning of a
# programming task is like facing an empty page at the beginning of a writing
# project. To make it easier to work through, one really good (but also really
# uncommon) approach is to walk away from the computer. Instead of trying to write
# code, we will first try to articulate the structure of our project - and not
# jumping to our keyboard works really well for this.

# Here is a productivity tip: work in such a way that you do not need to think
# about the non-important parts of your project. For us, this means having a
# standard layout for any project, and using it consistently. We will suggest one
# such layout below, but this is not the only one. There are an infinity of them,
# and the one that *works* is the one that works *for you*.

# Still, there are some good guidelines to follow.

# First, a project is a folder, everything in the project belongs to the folder,
# and everything outside the folder cannot belong to the project. This is
# important because it maximizes the chances that you can copy your project to
# another computer, and have it "just work". Of course in real life, things
# seldom "just work", and this is why we should pay extra care to the practices
# that maximise the chances of it being the case.

# !!! INFO This is not necessarily true if your project involves remote
# computing, or very large amounts of data. But then again, if you work in such
# a way, we expect that you will have read the documentation, and sought proper
# training.

# Second, file paths are not your friends. By far the biggest obstacle to
# reproducibility is the difference in ways to tell the computer *where files
# are*. We encourage to use *relative paths*, relative specifically to the
# folder in which your project lives. We will talk more about dealing with
# directories and paths and files in the [path] module.

# [path]: {{< ref "07_files/01_path.md" >}}

# Third, and final principle, similar things should be grouped together. In other
# words, it will be easier to navigate our project if there is a folder called
# `data` and it contains data, a folder called `figures` and it contains figures,
# and a folder called `code` which contains code. The name and variety of these
# folders is left up to you.

# With this in mind, here is a possible template for a project.

# ~~~
# .
# ├── .git                    # We use version control, always!
# │   └── ...
# ├── artifacts               # Outputs that are not figures go here
# │   └── summary.csv
# ├── code                    # Code that creates something goes here
# │   ├── figure01.jl
# │   └── simulations.jl
# ├── data                    # Raw data goes here
# │   └── BCI.data
# ├── lib                     # Useful functions go here
# │   ├── environmentaldata.jl
# │   └── model.jl
# ├── LICENSE                 # We use a license, always!
# ├── README.md               # Also mandatory: a README
# ├── Project.toml
# ├── Manifest.toml
# └── text                    # This folder can store notes and documents
#     └── notes.md
# ~~~

# There are a few files here on which it is worth spending a little more time.
# Their names are presented below as links, to the resource that we think is the
# most informative. It is, indeed, a very good idea to read the content of these
# links as well.

# The [README][readme] is a standard file for all projects, which gives
# information about the project, how to run it, the dependencies, who is in
# charge, *etc*. Writing a good README is a difficult task, but this is going to
# be the point of entry in your project. Show it some love.

# [LICENSE][license] is the text of a license, which gives information about
# intellectual property and your own liability regarding the use of your
# project. Picking FOSS (Free and Open Source Software) licenses is recommended,
# and there are a lot of the to accomodate different use cases. The [choose a
# license][cal] website is a very good place to get started.

# Finally, and these are language-specific, the [*Julia* package manager][pkg]
# will create files to track the dependencies of your project; `Project.toml`
# (which can be distributed alongside your project), and `Manifest.toml`, which
# is a machine-specific file with a *lot* of information. Check out the
# documentation.

# !!!INFO We will spend more time with the *Julia* package manager soon. It is a
# slightly unusual piece of software when coming from *e.g.* *R* or *Python*,
# but it is very powerful and makes reproducibility much, much easier.

# [readme]: https://mozilla.github.io/open-leadership-training-series/articles/opening-your-project/write-a-great-project-readme/
# [license]: https://choosealicense.com/
# [pkg]: https://julialang.github.io/Pkg.jl/v1/
# [cal]: https://choosealicense.com/
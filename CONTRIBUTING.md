# Hi!

Thanks for contributing to this project. Any addition and comment is useful, and
we're grateful that you are investing some time.

## How to contribute?

This is detailed in the README.

## How to setup your development environment?

At the very least, you will need Jupyter on your machine. They offer
[installation instructions on their website][instjup].

If you intend to run the code in the notebooks, you will need a working
[Julia][jlinst] installation. These lessons will target the latest stable
release. Finally, you will need [IJulia][ijulinst] to run the Julia kernel.

When you have forked the lesson, start by creating a new branch *with an
explicit name*. Something like `lesson2-clarify-while` is helpful. As soon as
this is done, open a pull request against the `master` branch, so we can keep
track of what happens.

[instjup]: http://jupyter.org/install.html
[jlinst]: https://julialang.org/downloads/
[ijulinst]: https://github.com/JuliaLang/IJulia.jl

## A note about Jupyter notebooks in GitHub

Because Jupyter notebooks store the output, and the execution order, things can
get messy from a version control point of view. We highly recommend that before
submitting a pull request, you *Clean all output* and *Shutdown the kernel* for
the lessons you are working on. This will put the lessons in "blank slate" mode,
where learners can start.

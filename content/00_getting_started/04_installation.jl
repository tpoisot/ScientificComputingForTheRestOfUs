# ---
# title: Installing Julia
# status: beta
# ---

# In this module, we will see how we can install *Julia*, setup a default
# version, and go through some of the usual tools involved in setting up a good
# *Julia* development environment

# <!--more-->

# The easiest way to install *Julia* is to rely on the `juliaup` utility, which
# can be downloaded for most platforms from its [GitHub page][juliaup].

# [juliaup]: https://github.com/JuliaLang/juliaup

# Once the `juliaup` program is executed, installing the current released
# version of *Julia* can be done by starting your command prompt, and typing

# ~~~
# juliaup add release
# ~~~

# This will take care of downloading and installing the correct latest release
# for your computer, but also make it available on your path (which is to say,
# if you type `julia` in a command prompt, *Julia* will start).

# Another function of `juliaup` is to serve a version multiplexer: it allows to
# have different versions of the *Julia* installed on the same computer. We will
# not use this functionality here, but for the sake of being epxlicit, we will
# specify a default version:

# ~~~
# juliaup default release
# ~~~

# This will ensure that the command `julia` will start the currently released
# version. This is important to keep in mind, because this website is generated
# using the current *Julia* release, and so you might not get the exact same
# result if you use a very old version of the language.

# The idea behind this material is to type as much of it as possible in the
# *Julia* REPL (*i.e.* what happens when you start `julia`). In practice, most
# (all?) coding is done in a text editor. For *Julia*, the one with the best
# support is VSCode, which is free, and has a [dedicated *Julia*
# plugin][jlvscode].

# [jlvscode]: https://www.julia-vscode.org/

# The Julia VSCode plugin website has a full documentation of what can be done
# -- it is, essentially, working under the same logic as *e.g.* RStudio, only
# for any language.

# !!!OPINION We like Julia in VSCode because there are a lot of user-friendly
# additions that make it easy to track bug, identify bottlenecks, and understand
# what is loaded in your environment. That being said, there are a number of
# other solutions to develop *Julia* documents, including *Jupyter*, *Pluto*,
# *Quarto*, vim and lsp, etc...

# One characteristic of *Julia* is that it has amazing support for unicode
# characters, enabling to, for example, use mathematical symbols to reproduce
# mathematical notation. This assumes that your font will have good support for
# these characters.

# One such font is [JuliaMono](https://juliamono.netlify.app/). Other very
# popular alternatives, all free, are [Recursive](https://www.recursive.design/)
# (this entire website is set in Recursive!), [JetBrains
# Mono](https://www.jetbrains.com/lp/mono/),
# [Hack](https://sourcefoundry.org/hack/), [Cascadia
# Code](https://github.com/microsoft/cascadia-code), and
# [Iosevka](https://typeof.net/Iosevka/). There are many others, but these fonts
# have good symbol coverage, and tend to be very legible on all screens. Feel
# free to experiment with one that suits you -- setting up a good environment is
# also about your own user experience, and having a font that does not strain
# your eyes or make differentiating between symbols difficult is *definitely* a
# part of it.

# Ideally, the font you pick should let you differentiate between these
# characters:

# ~~~
# 1lIL
# 0Oo
# ~~~

# When you are all set with your installation of *Julia* (and any additional
# packages), it is time to conclude this section, and start with the
# fundamentals.